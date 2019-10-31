import images from './*.png'

export default \
parties =

  # main
  con:
    name: "Conservative Party"
    leans: 'right'
    img: images.con
  lab:
    name: "Labour Party"
    leans: 'left'
    img: images.lab

  # secondary
  dup:
    name: "Democratic Unionist Party"
    leans: 'right'
  snp:
    name: "Scottish National Party"
    leans: 'left'
    img: images.snp
  lib:
    name: "Liberal Democrats"
    leans: 'left'
    img: images.lib

  ukip:
    name: "UK Independence Party"
    leans: 'right'
    img: images.ukip
  uup:
    name: "Ulster Unionist Party"
    leans: 'right'
    img: images.uup

  green:
    name: "Green Party"
    leans: 'left'
    img: images.green
  plaid:
    name: "Plaid Cymru"
    leans: 'left'
    img: images.plaid
  sf:
    name: "Sinn Féin"
    leans: 'left'
    img: images.sf
  sdlp:
    name: "Social Democratic and Labour Party"
    leans: 'left'
    img: images.sdlp
  alliance:
    name: "Alliance Party of Northern Ireland"
    leans: 'left'
    img: images.alliance

  min:
    name: "MIN" # what is this?
    img: images.min

  # single-issue
  brexit:
    name: "Brexit Party"
    img: images.brexit

  # other
  other:
    name: "Independent"
    img: images.other

  anyone:
    name: "Anyone"
