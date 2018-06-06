import store from '/store'

export selectWard = (ward)->
  store.dispatch Object.assign {}, {ward}, type: 'WARDS_SELECT'

export getLocation = ->
  navigator.geolocation.getCurrentPosition (position)->
    {latitude, longitude} = position.coords
    store.dispatch Object.assign {}, {latitude, longitude}, type: 'LOCATION_SET'
