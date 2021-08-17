import React        from "react"
import { render }   from "react-dom"
import axios        from 'axios'
import throttle     from 'underscore-es/throttle'

import './styles'
import './election/locales'

# provide GTM fallback
window.gtag ?= -> window.dataLayer?.push arguments

import { parties, date } from "/election"

# routes
import Application  from '/routes/application'

do ->
  if dsn = process.env.SENTRY_DSN_FRONTEND
    Sentry = await import('@sentry/browser')
    Sentry.init { dsn, environment: process.env.NODE_ENV }

  polls = await import('/election/polls.json')

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
      navigator.geolocation.getCurrentPosition resolve, reject, timeout: 5000
    {latitude, longitude} = position.coords
    {latitude, longitude}

  getRiding = (lat, lng)->
    { data } = await axios.get "#{process.env.RIDING_URL}/#{lat.toFixed 2},#{lng.toFixed 2}"
    data

  fixVh = ->
    document.documentElement.style.setProperty '--vh', "#{window.innerHeight * 0.01}px"


  class App extends React.Component
    constructor: ->
      super arguments...
      @state =
        riding: null
        locating: false
        geoError: null

    componentDidMount: ->
      @autoLocate()
      fixVh()

    autoLocate: =>
      try
        @setState locating: true
        {latitude, longitude} = await getLocation()
        if latitude and longitude and riding = await getRiding latitude, longitude
          gtag 'event', 'riding-select-auto', event_category: 'engagement', event_label: riding
          @setRiding matchRiding riding
      catch err
        # retry a timeout once
        setTimeout @autoLocate.bind(@), 0 if err.TIMEOUT unless @state.geoError
        @setState geoError: err.message
        @setRiding polls?[0]?.riding unless @state.riding
      finally
        @setState locating: false

    setRiding: (riding)=>
      @setState { riding }

    render: ->
      <Application
        polls={polls}
        parties={parties}
        date={date}
        riding={@state.riding}
        setRiding={@setRiding}
        locating={@state.locating}
      />

  render <App />, document.getElementById "Application"
