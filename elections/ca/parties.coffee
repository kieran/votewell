import images from './*.png'

export default \
parties =

  # main
  pc:
    name: "Conservative Party"
    leans: 'right'
    img: images.pc
  lib:
    name: "Liberal Party"
    leans: 'left'
    img: images.lib

  # secondary
  ndp:
    name: "NDP"
    leans: 'left'
    img: images.ndp
  gpc:
    name: "Green Party"
    leans: 'left'
    img: images.gpc

  # single-issue
  bloc:
    name: "Bloc Quebecois"
    img: images.bloc

  # other
  other:
    name: "Independent"
    img: images.other

  anyone:
    name: "Anyone"
