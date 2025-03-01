# import images from './*.png'

`const lpc = new URL('./lpc.png', import.meta.url);`
`const ndp = new URL('./ndp.png', import.meta.url);`
`const gpc = new URL('./gpc.png', import.meta.url);`
`const bq = new URL('./bq.png', import.meta.url);`

export date = '2025-10-20'

export progressives = 'lpc ndp gpc bq'.split ' '
export cons = 'cpc'.split ' '

export parties =
  cpc:
    name: "Conservative Party"
    leans: 'right'

  lpc:
    name: "Liberal Party"
    leans: 'left'
    img: lpc

  ndp:
    name: "NDP"
    leans: 'left'
    img: ndp

  gpc:
    name: "Green Party"
    leans: 'left'
    img: gpc

  # other / independent
  ppc:
    name: "People's Party"

  bq:
    name: "Bloc Québécois"
    img: bq

  ind:
    name: "Independent"

  anyone:
    name: "Anyone"
