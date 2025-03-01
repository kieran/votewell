fs      = require 'fs'
axios   = require 'axios'

cheerio = require 'cheerio'
{ chunk } = require 'underscore'
util = require 'util'
{ exec } = require 'child_process'
exec = util.promisify exec

{ log } = console

NUM_RIDINGS = 343
polls = []

PROJ_COLUMNS = 4

please_fetch = (url)->
  log "fetching #{url} ..."
  try
    { data } = await axios url
  catch
    console.log "retrying #{url} ..."
    { data } = await axios url
  data

do ->
  try
    await exec "git pull --rebase --autostash"

    $ridings_index = cheerio.load await please_fetch "https://338canada.com/districts.htm"
    riding_url_selector = 'table tbody tr td[align="left"] a[target="_blank"]'
    riding_urls = $ridings_index(riding_url_selector).toArray().map (el)-> el.attribs?.href?.trim?()

    for riding_url in riding_urls
      $riding_page = cheerio.load await please_fetch riding_url

      riding = $riding_page("title").text().split(' | ')[0]
      log riding
      ar = $riding_page('svg[id*="ridinghisto"] > text').toArray().map((el)-> $riding_page(el).text())
      ar = ar.slice PROJ_COLUMNS-1 # remove header cells
      log ar


      projections = {riding}
      prevs = []
      for row in chunk ar, PROJ_COLUMNS
        [name, ..., prev, proj_text] = row
        name = name.toLowerCase()
        prevs.push { name, value: parseFloat prev }
        [proj, moe] = proj_text.match(/\d+/g).map (n)-> parseFloat n
        projections[name] = {name, proj, moe}

      # assign incumbency
      incumbent = prevs.toSorted((a,b)-> b.value - a.value)[0].name
      projections[incumbent].incumbent = true
      projections.incumbent = incumbent
      log projections

      polls.push projections


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
