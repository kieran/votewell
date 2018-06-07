import React        from "react"
import { render }   from "react-dom"
import sortBy       from 'underscore-es/sortBy'
import findIndex    from 'underscore-es/findIndex'
import tag          from "@turf/tag"
import ReactSelect  from 'react-select'

import 'react-select/dist/react-select.css'
import './styles'

# components
import Spinner  from 'react-spinkit'
import Chart    from '/components/chart'

import {
  FacebookShareButton
  TwitterShareButton
  RedditShareButton
  EmailShareButton
  FacebookIcon
  TwitterIcon
  RedditIcon
  EmailIcon
} from 'react-share'

# assets
import grn from '/assets/grn.png'
import lib from '/assets/lib.png'
import ndp from '/assets/ndp.png'

parties =
  lib:
    name: "Liberal Party"
    img: lib
  ndp:
    name: "NDP"
    img: ndp
  grn:
    name: "Green Party"
    img: grn

import container from './container'

export default \
container \
class Application extends React.Component

  constructor: ->
    super arguments...
    @state =
      ward_name: null

  componentDidMount: ->
    @props.getLocation()
    setTimeout =>
      unless @state.ward_name
        @setState ward_name: @props.wards[0].properties.ENGLISH_NA
    , 4000


  pollsFor: (ward_name)->
    for poll in @props.polls
      return poll if poll.name is ward_name
    console.log "couldn't match #{ward_name} with poll data"

  findWard: ->
    points =
      type: "FeatureCollection"
      features: [
        type: 'Feature'
        geometry:
          type: 'Point'
          coordinates: [@props.location.longitude, @props.location.latitude]
        properties: {}
      ]

    lol = tag points, @props.geoJson, 'ENGLISH_NA', 'ward_name'
    name = lol.features[0]?.properties?.ward_name

  selectWard: (evt)=>
    @setState ward_name: evt?.target?.value or evt?.value

  pollData: =>
    polls = @pollsFor @state.ward_name
    (name: key, value: val for key, val of polls when key in 'pc lib ndp grn other'.split ' ')

  bestOption: =>
    sorted = sortBy(@pollData(), 'value').reverse()
    pcIndex = findIndex(sorted, { name: 'pc' })
    if pcIndex > 0
      return parties[sorted[0]['name']]
    for obj in sorted
      return parties[obj.name] unless obj.name is 'pc'

  render: ->
    if @props.location?.longitude and not @state.ward_name
      setTimeout =>
        @setState ward_name: @findWard()

    <div className="wards">
      {if @state.ward_name
        [
          @share()
          @reco()
          @chart()
          @attribution()
        ]
      else
        @spinner()
      }
    </div>


  share: ->
    url = window.location.href
    <div className="share">
      <FacebookShareButton url={url}>
        <FacebookIcon size={32} round={true}/>
      </FacebookShareButton>
      <TwitterShareButton url={url}>
        <TwitterIcon size={32} round={true}/>
      </TwitterShareButton>
      <RedditShareButton url={url}>
        <RedditIcon size={32} round={true}/>
      </RedditShareButton>
      <EmailShareButton
        url={window.location.href}
        subject="VoteWell: A strategic voting tool for the 2018 Ontario election"
      >
        <EmailIcon size={32} round={true}/>
      </EmailShareButton>
    </div>

  spinner: ->
    <div className="spinner">
      <Spinner className="ball-triangle-path"/>
    </div>

  reco: ->
    <div className="reco">
      <h1>A strategic vote in</h1>
      <ReactSelect
        className="ward-selector"
        style={{width: 350}}
        clearable={false}
        value={@state.ward_name}
        options={((n = ward.properties.ENGLISH_NA) and label: n, value: n for ward in @props.wards)}
        onChange={@selectWard}
      />
      <h1>is a vote for</h1>
      <img src={@bestOption().img} alt={"#{@bestOption().name}"}/>
    </div>

  chart: ->
    <div className="chart">
      <Chart data={@pollData()} height={150}/>
    </div>

  attribution: ->
    <div className="attribution">
      <a href="http://www.calculatedpolitics.com/project/2018-ontario/">Projection data</a>
      <a href="https://www.elections.on.ca/en/voting-in-ontario/electoral-districts/current-electoral-district-maps.html">Map data</a>
      <a href="https://github.com/kieran/votewell">Code on GitHub</a>
    </div>
