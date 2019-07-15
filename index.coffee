import React        from "react"
import { render }   from "react-dom"
import axios        from 'axios'

import './styles'

# bundle assets - full URL in html
import './assets/votewell.png'
import './assets/favicon-128x128.png'
import './assets/favicon-64x64.png'
import './assets/favicon-32x32.png'
import './assets/favicon-16x16.png'

# routes
import Application  from '/routes/application'

import polls from '/data/polls.json'

getLocation = ->
  new Promise (resolve, reject)->
    navigator.geolocation.getCurrentPosition resolve, reject
  .then (position)->
    {latitude, longitude} = position.coords
    {latitude, longitude}

getRiding = (lat, lng)->
  { data } = await axios.get "#{process.env.API_HOST}/#{lat},#{lng}"
  data

class App extends React.Component
  constructor: ->
    super arguments...
    @state =
      riding: null

    @autoLocate()

    defaultRiding = polls?[0]?.riding or 'Banff—Airdrie'
    setTimeout =>
      @setRiding defaultRiding unless @state.riding
    , 5000

  autoLocate: =>
    try
      {latitude, longitude} = await getLocation()
      if latitude and longitude
        if riding = await getRiding latitude, longitude
          @setRiding riding

  setRiding: (riding)=>
    @setState { riding }

  render: ->
    <Application
      polls={polls}
      riding={@state.riding}
      setRiding={@setRiding}
    />

render <App />, document.getElementById "Application"
