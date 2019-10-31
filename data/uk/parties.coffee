import lab    from './lab.png'
import lib    from './lib.png'
import dup    from './dup.png'
import green  from './green.png'
import plaid  from './plaid.png'
import snp    from './snp.png'
import sf     from './sf.png'
import sdlp   from './sdlp.png'
import alliance from './alliance.png'

export default \
parties =

  # main
  con:
    name: "Conservative Party"
    leans: 'right'
  lab:
    name: "Labour Party"
    leans: 'left'
    img: lab

  # secondary
  dup:
    name: "Democratic Unionist Party"
    leans: 'right'
  snp:
    name: "Scottish National Party"
    leans: 'left'
    img: snp
  lib:
    name: "Liberal Democrats"
    leans: 'left'
    img: lib

  ukip:
    name: "UK Independence Party"
    leans: 'right'
  uup:
    name: "Ulster Unionist Party"
    leans: 'right'

  green:
    name: "Green Party"
    leans: 'left'
    img: green
  plaid:
    name: "Plaid Cymru"
    leans: 'left'
    img: plaid
  sf:
    name: "Sinn Féin"
    leans: 'left'
    img: sf
  sdlp:
    name: "Social Democratic and Labour Party"
    leans: 'left'
    img: sdlp
  alliance:
    name: "Alliance Party of Northern Ireland"
    leans: 'left'
    img: alliance

  min:
    name: "MIN" # what is this?

  # single-issue
  brexit:
    name: "Brexit Party"

  # other
  other:
    name: "Independent"

  anyone:
    name: "Anyone"
