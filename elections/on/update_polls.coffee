fs      = require 'fs'
axios   = require 'axios'

cheerio = require 'cheerio'
{ chunk } = require 'underscore'


util = require 'util'
{ exec } = require 'child_process'
exec = util.promisify exec

NUM_RIDINGS = 124
polls = []

PROJ_COLUMNS = 5

do ->
  try
    await exec "git pull --rebase --autostash"

    for riding_number in [1..NUM_RIDINGS]
      url = "https://338canada.com/ontario/#{1000+riding_number}e.htm"
      console.log "fetching #{url} ..."

      # the first req to this domain always gets a ECONNRESET for some reason
      try
        { data } = await axios url
      catch
        console.log "retrying #{url} ..."
        { data } = await axios url

      $ = cheerio.load data
      riding = $("title").text().split(' | ')[0]

      ar = ($("#ridinghisto-#{riding_number - 1} > text").toArray().map (el)-> $(el).text()).slice(PROJ_COLUMNS-1)

      projections = Object.fromEntries(chunk(ar, PROJ_COLUMNS).map((a)=>[a[0].toLowerCase(),parseFloat((a[PROJ_COLUMNS-1]).split('%')[0])]))
      incumbent = chunk(ar, PROJ_COLUMNS).map((a)=>[a[0].toLowerCase(),parseFloat((a[PROJ_COLUMNS-2]).split('%')[0])]).toSorted((a,b)-> b[1] - a[1])[0][0]

      polls.push { riding, incumbent, ...projections }

    throw "unexpected number of ridings: #{polls.length}" unless polls.length is NUM_RIDINGS
    fs.writeFileSync "#{__dirname}/polls.json", JSON.stringify polls, undefined, 2

    # push to GH if there are poll changes
    { stdout, stderr } = await exec "git diff #{__dirname}/polls.json"
    if stdout
      await exec "git add #{__dirname}/polls.json"
      { stdout, stderr } = await exec "date +'%b %d at %l%p'"
      await exec "git commit -m 'poll update - #{stdout.replace /\s+/g, ' '}'"
      await exec "git push origin master"

  catch err
    console.log err
