fs      = require 'fs'
util    = require 'util'
{ exec } = require 'child_process'
exec    = util.promisify exec

puppeteer     = require 'puppeteer-extra'
StealthPlugin = require 'puppeteer-extra-plugin-stealth'
puppeteer.use StealthPlugin()

DISTRICTS_URL = 'https://338canada.com/bc/districts.htm'

NUM_RIDINGS = 93

# smoke test with a handful of ridings: LIMIT=3 npm run update_polls
# never writes polls.json and never touches git
LIMIT = if limit = process.env.LIMIT then parseInt limit, 10 else NUM_RIDINGS

# 338 shows the sitting MLA's current party as a badge. It's a better
# incumbent than the last election result -- plenty of MLAs have crossed
# the floor or quit their party since 2024.
BADGE_PARTY =
  C:  'cpbc'  # Conservative Party of BC
  N:  'ndp'   # New Democratic Party
  G:  'bcg'   # BC Green Party
  O:  'one'   # OneBC
  CE: 'cen'   # Centre BC
  # 'I' (independent) and '' (vacant) have no party to mark

# https://338canada.com serves ads via Ezoic, which paints a full-viewport
# interstitial over the top of the district links. It swallows clicks, and
# it isn't what we're here for, so take it off the page.
dismissAds = (page)->
  await page.evaluate ->
    for el in document.querySelectorAll 'ins[id*=Interstitial], .ezoic-ad, [id^=ezoic-pub-ad-]'
      el.remove()

pause = (lo, hi)->
  new Promise (resolve) -> setTimeout resolve, lo + Math.random() * (hi - lo)

# every riding link on the index is target=_blank, so a real click opens a
# new tab. go back to the index each time and actually click the link.
scrapeRiding = (page, index)->
  await page.goto DISTRICTS_URL, waitUntil: 'domcontentloaded'

  # Ezoic only injects its interstitial after the document has parsed, so
  # give it a moment to paint over the links before clicking
  await pause 500, 1200

  links = await page.$$ '#myTable a[target="_blank"]'
  link = links[index]

  for attempt in [1..3]
    await dismissAds page
    # puppeteer 24 dropped page.waitForEvent, but Page is still an
    # EventEmitter and the CDP backend still emits 'popup' for target=_blank
    clicked = new Promise (resolve, reject) ->
      page.once 'popup', resolve
      link.click().catch reject
    try
      riding = await clicked
      break
    catch err
      throw err unless attempt is 3
      await pause 500, 1000

  await riding.waitForSelector '.riding-badge', timeout: 30_000
  await dismissAds riding
  await pause 200, 600

  result = await riding.evaluate ->
    riding: document.querySelector('.projection-header-text h1')?.textContent.trim()
    badge: document.querySelector('.riding-badge')?.textContent.trim()

    # 338 embeds the vote projection as a plain object in the page source:
    #   parties[].values / parties[].moe are one entry per projection date
    # the current projection is the last one. This is the only place that
    # carries every party -- the "Projection" column of the history table
    # silently drops Centre BC and most of OneBC.
    parties: window.districtvote_DATA?.parties
      .filter (party) => party.values.length
      .map (party) =>
        name: party.key.toLowerCase()
        proj: Math.round party.values.at(-1)
        moe: Math.round party.moe.at(-1)

  await riding.close()
  result

do ->
  try
    # set PUSH=0 to write polls.json locally and leave git alone
    PUSH = process.env.PUSH isnt '0'

    unless LIMIT is NUM_RIDINGS
      console.log "smoke test: scraping #{LIMIT} of #{NUM_RIDINGS} ridings, not writing any files"

    await exec "git pull --rebase --autostash" if LIMIT is NUM_RIDINGS and PUSH

    browser = await puppeteer.launch
      headless: !process.env.HEADFUL
      args: ['--window-size=1440,900']
    page = await browser.newPage()
    await page.setViewport width: 1440, height: 900

    try
      polls = []
      for index in [0...LIMIT]
        { riding, badge, parties } = await scrapeRiding page, index
        parties = parties.toSorted (a, b) -> b.proj - a.proj
        console.log "#{riding} (#{badge || 'vacant'}) #{parties.map((p) -> "#{p.name} #{p.proj}±#{p.moe}").join '  '}"

        poll = { riding }
        for party in parties
          poll[party.name] = { name: party.name, proj: party.proj, moe: party.moe }

        # ridings sitting with an independent or a vacant seat get no
        # incumbent -- better to say nothing than to guess
        if incumbent = BADGE_PARTY[badge]
          poll[incumbent].incumbent = true
          poll.incumbent = incumbent

        polls.push poll
    finally
      await browser.close()

    if LIMIT is NUM_RIDINGS
      throw "unexpected number of ridings: #{polls.length}" unless polls.length is NUM_RIDINGS
      fs.writeFileSync "#{__dirname}/polls.json", JSON.stringify polls, undefined, 2

      if PUSH
        # push to GH if there are poll changes
        { stdout } = await exec "git diff #{__dirname}/polls.json"
        if stdout
          await exec "git add #{__dirname}/polls.json"
          { stdout } = await exec "date +'%b %d at %l%p'"
          await exec "git commit -m 'poll update - #{stdout.replace /\s+/g, ' '}'"
          await exec "git push origin master"

    else
      console.log "\n#{JSON.stringify polls, undefined, 2}"

  catch err
    console.error err
    process.exit 1
