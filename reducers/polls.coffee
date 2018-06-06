import omit from 'underscore-es/omit'

import poll_data from '/data/polls'

export default polls = (state=poll_data, action)->
  params = omit action, 'type'
  switch action.type
    when 'POLLS_SET'
      params
    else
      state
