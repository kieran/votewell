fs      = require 'fs'
axios   = require 'axios'
cheerio = require 'cheerio'

util = require 'util'
{ exec } = require 'child_process'
exec = util.promisify exec

NUM_RIDINGS = 124
polls = []

urls = [
  'https://calculatedpolitics.ca/projection/next-ontario-provincial-election-projection/'
]

polls_regex = ///^
  (?<riding>.+\S)   \s+ # Riding name
  [\w.]+            \s+ # (incumbant)
  (?<pc>\d+)        \s+ # Conservative
  (?<ndp>\d+)       \s+ # NDP
  (?<lib>\d+)       \s+ # Liberal
  (?<gpc>\d+)       \s+ # Green
  (?<other>\d+)         # Other
  .*                    # (projection etc)
$///mg

do ->
  try
    for url in urls
      console.log "fetching #{url} ..."

      # the first req to this domain always gets a ECONNRESET for some reason
      try
        { data } = await axios url
      catch
        console.log "retrying #{url} ..."
        { data } = await axios url

      # fix lack of spaces in tables
      data = data
        .replaceAll '</td>',  ' </td>'
        .replaceAll '</tr>',  '\n</tr>'

      $ = cheerio.load data
      for table in $ 'table.row:last'
        text = $(table).text()

        while res = polls_regex.exec text
          { riding, pc, ndp, lib, gpc, other } = res.groups
          polls.push {
            riding
            pc:     parseInt pc
            ndp:    parseInt ndp
            lib:    parseInt lib
            gpc:    parseInt gpc
            other:  parseInt other
          }

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
