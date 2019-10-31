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
      { data } = await axios url
      $ = cheerio.load data
      for riding in $ '.conlistseat'

        obj = {}

        obj.riding = $(riding).find('.seat').text()

        for proj in $(riding).find 'table.center tr[class]'
          name = $(proj).find('td').first().text()
          perc = parseFloat $(proj).find('td').last().text().replace /[^\d\.]/g, ''
          obj[name.toLowerCase()] = perc

        # rename oth -> other
        obj.other = obj.oth
        obj.oth = undefined

        polls.push obj

    fs.writeFileSync "#{__dirname}/polls.json", JSON.stringify polls, undefined, 2

  catch err
    console.log err
