import omit   from 'underscore-es/omit'
import sortBy from 'underscore-es/sortBy'

import data from '/data/wards'

export geoJson = (state=data, action)->
  state

sortedWards = sortBy data.features, (w)-> w.properties.ENGLISH_NA

export wards = (state=sortedWards, action)->
  params = omit action, 'type'
  switch action.type
    when 'WARDS_ADD'
      nextState = (t for t in state when t isnt params.ward)
      nextState.push params.ward
      nextState
    when 'WARDS_REMOVE'
      (t for t in state when t isnt params.ward)
    when 'WARDS_CLEAR'
      []
    else
      state

export selectedWard = (state=null, action)->
  params = omit action, 'type'
  switch action.type
    when 'WARDS_SELECT'
      params.ward
    when 'WARDS_CLEAR'
      null
    else
      state
