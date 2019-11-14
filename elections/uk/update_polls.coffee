fs      = require 'fs'
axios   = require 'axios'
cheerio = require 'cheerio'

util = require 'util'
{ exec } = require 'child_process'
exec = util.promisify exec

polls = []

urls = [
  'https://www.electoralcalculus.co.uk/conlist_a_b.html'
  'https://www.electoralcalculus.co.uk/conlist_c_e.html'
  'https://www.electoralcalculus.co.uk/conlist_f_k.html'
  'https://www.electoralcalculus.co.uk/conlist_l_q.html'
  'https://www.electoralcalculus.co.uk/conlist_r_s.html'
  'https://www.electoralcalculus.co.uk/conlist_t_z.html'
  'https://www.electoralcalculus.co.uk/conlist_wales.html'
  'https://www.electoralcalculus.co.uk/conlist_scot.html'
  'https://www.electoralcalculus.co.uk/conlist_ni.html'
]

do ->
  try
    for url in urls
      console.log "fetching #{url} ..."
      { data } = await axios url
      $ = cheerio.load data
      for riding in $ '.conlistseat'

        obj = {}
        other = 0

        obj.riding = $(riding).find('.seat').text()

        for proj in $(riding).find 'table.center tr[class]'
          name = $(proj).find('td').first().text().toLowerCase()
          value = parseFloat $(proj).find('td').last().text().replace /[^\d\.]/g, ''

          if value < 1 or name is 'oth'
            other = parseFloat (other + value).toFixed 1
          else
            obj[name] = value

        polls.push { obj..., other }

    fs.writeFileSync "#{__dirname}/polls.json", JSON.stringify polls, undefined, 2

    # push to GH if there are poll changes
    { stdout, stderr } = await exec "git diff #{__dirname}/polls.json"
    if stdout
      await exec "git add #{__dirname}/polls.json"
      { stdout, stderr } = await exec "date +'%b %d at %l%p'"
      await exec "git commit -m 'poll update - #{stdout.replace /\s+/, ' '}'"
      await exec "git push origin master"

  catch err
    console.log err
