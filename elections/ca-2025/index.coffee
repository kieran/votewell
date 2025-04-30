import images from './*.png'

export date = '2025-04-28'

export progressives = 'lpc ndp gpc bq'.split ' '
export cons = 'cpc'.split ' '

export parties =
  cpc:
    name: "Conservative Party"
    leans: 'right'
    img: images.pcp

  lpc:
    name: "Liberal Party"
    leans: 'left'
    img: images.lpc

  ndp:
    name: "NDP"
    leans: 'left'
    img: images.ndp

  gpc:
    name: "Green Party"
    leans: 'left'
    img: images.gpc

  # other / independent
  ppc:
    name: "People's Party"

  bq:
    name: "Bloc Québécois"
    img: images.bq

  ind:
    name: "Independent"

  anyone:
    name: "Anyone"
