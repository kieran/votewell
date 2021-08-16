fs      = require 'fs'
axios   = require 'axios'
cheerio = require 'cheerio'

util = require 'util'
{ exec } = require 'child_process'
exec = util.promisify exec

polls = []

urls = [
  'https://calculatedpolitics.ca/projection/canadian-federal-election-ontario/'
  'https://calculatedpolitics.ca/projection/canadian-federal-election-quebec/'
  'https://calculatedpolitics.ca/projection/canadian-federal-election-bc/'
  'https://calculatedpolitics.ca/projection/canadian-federal-election-alberta/'
  'https://calculatedpolitics.ca/projection/canadian-federal-election-prairies/'
  'https://calculatedpolitics.ca/projection/canadian-federal-election-atlantic/'
  'https://calculatedpolitics.ca/projection/canadian-federal-election-north/'
]

polls_regex = ///^
  (?<riding>.+\S)   \s+ # Riding name
  [\w.]+            \s+ # (incumbant)
  (?<lib>\d+)       \s+ # Liberal
  (?<pc>\d+)        \s+ # Conservative
  (?<ndp>\d+)       \s+ # NDP
  (?<bloc>\d+)      \s+ # Bloc
  (?<gpc>\d+)       \s+ # Green
  (?<other>\d+)         # Other
  .*                    # (projection etc)
$///mg

do ->
  try
    for url in urls
      console.log "fetching #{url} ..."

      { data } = await axios url

      $ = cheerio.load data
      for table in $ 'table.row'
        text = $(table).text()

        while res = polls_regex.exec text
          { riding, pc, ndp, lib, bloc, gpc, other } = res.groups
          polls.push {
            riding
            pc:     parseInt pc
            ndp:    parseInt ndp
            lib:    parseInt lib
            bloc:   parseInt bloc
            gpc:    parseInt gpc
            other:  parseInt other
          }

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
