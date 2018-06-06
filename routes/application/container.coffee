import { connect } from 'react-redux'

# provide state
mapStateToProps = (state)->
  state

# provide actions
import { selectWard, getLocation } from '/actions/wards'

mapDispatchToProps = (dispatch)->
  selectWard: (w)-> selectWard w
  getLocation: -> getLocation()

export default connect mapStateToProps, mapDispatchToProps
