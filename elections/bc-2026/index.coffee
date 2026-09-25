import images from './*.png'

export date = '2026-10-24'

export progressives = 'ndp bcg'.split ' '
export cons = 'cpbc bcu'.split ' '

export parties =

  # main
  cpbc:
    name: "Conservative Party of BC"
    leans: 'right'
  ndp:
    name: "NDP"
    leans: 'left'
    img: images.ndp
  bcg:
    name: "BC Green Party"
    leans: 'left'
    img: images.bcg

  # also running
  one:
    name: "OneBC"
  cen:
    name: "Centre BC"
  bcu:
    name: "BC United"
    leans: 'right'

  # other
  ind:
    name: "Independent"

  anyone:
    name: "Anyone"
