import React        from "react"
import { render }   from "react-dom"
import axios        from 'axios'
import * as Sentry  from '@sentry/browser'

if dsn = process.env.SENTRY_DSN
  Sentry.init { dsn }

import './styles'
import './locales'

# bundle assets - full URL in html
import './assets/votewell.png'
import './assets/favicon-128x128.png'
import './assets/favicon-64x64.png'
import './assets/favicon-32x32.png'
import './assets/favicon-16x16.png'

# routes
import Application  from '/routes/application'

import polls from '/data/polls.json'

# fuzzy riding name matcher
# removes weird dash / apostrophe mis-matches
matchRiding = (name='')->
  ridings = (poll.riding for poll in polls)
  match_name = name.replace /[^A-Za-z]/g, ''
  for riding in ridings
    return riding if match_name is riding.replace /[^A-Za-z]/g, ''
  ridings[0]

getLocation = ->
  position = await new Promise (resolve, reject)->
    navigator.geolocation.getCurrentPosition resolve, reject
  {latitude, longitude} = position.coords
  {latitude, longitude}

getRiding = (lat, lng)->
  { data } = await axios.get "#{process.env.API_HOST}/#{lat.toFixed 2},#{lng.toFixed 2}"
  data

class App extends React.Component
  constructor: ->
    super arguments...
    @state =
      riding: null
      locating: false

  componentDidMount: ->
    @autoLocate()

    setTimeout =>
      unless @state.riding
        @setState locating: true
        @setRiding polls?[0]?.riding
    , 5000

  autoLocate: =>
    try
      @setState locating: true
      {latitude, longitude} = await getLocation()
      if latitude and longitude
        if riding = await getRiding latitude, longitude
          @setRiding matchRiding riding
    finally
      @setState locating: false

  setRiding: (riding)=>
    @setState { riding }

  render: ->
    <Application
      polls={polls}
      riding={@state.riding}
      setRiding={@setRiding}
      autoLocate={@autoLocate}
      locating={@state.locating}
    />

render <App />, document.getElementById "Application"
