import omit from 'underscore-es/omit'

export default location = (state=null, action)->
  params = omit action, 'type'
  switch action.type
    when 'LOCATION_SET'
      params
    else
      state
