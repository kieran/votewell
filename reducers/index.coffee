import { combineReducers } from 'redux'

import { geoJson, wards, selectedWard } from './wards'
import location from './location'
import polls from './polls'

export default combineReducers({
  geoJson
  wards
  selectedWard
  location
  polls
})
