fs      = require 'fs'
axios   = require 'axios'
cheerio = require 'cheerio'

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

  catch err
    console.log err
