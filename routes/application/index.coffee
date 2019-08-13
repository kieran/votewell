import React        from "react"
import { render }   from "react-dom"
import sortBy       from 'underscore-es/sortBy'
import findIndex    from 'underscore-es/findIndex'
import ReactSelect  from 'react-select'
import { Helmet }   from "react-helmet"
import {
  withTranslation
} from 'react-i18next'

import 'react-select/dist/react-select.css'
import './styles'

# components
import Spinner  from 'react-spinkit'
import Chart    from '/components/chart'
import Marker   from '/assets/map-marker.svg'


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
import anyone from '/assets/anyone.png'

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
  anyone:
    name: "Anyone"
    img: anyone

leftists = Object.keys parties

sum = (arr=[])-> arr.reduce ((a,b)-> a+b), 0
avg = (arr=[])-> sum(arr) / arr.length
probablyMobile = matchMedia?('(orientation: portrait) and (max-width: 600px)')?.matches or false

export default \
withTranslation() \
class Application extends React.Component
  pollsFor: (riding)->
    for poll in @props.polls
      return poll if poll.riding is riding
    console.log "couldn't match #{riding} with poll data"

  selectRiding: (evt)=>
    if riding = evt?.target?.value or evt?.value
      @props.setRiding riding

  setLang: (lang)=>
    @props.i18n.changeLanguage lang

  pollData: =>
    polls = @pollsFor @props.riding
    (name: key, value: val for key, val of polls when val and key in 'pc lib ndp grn bloc other'.split ' ')

  bestOption: =>
    sorted = sortBy(@pollData(), 'value').reverse()

    # vote strategically if there are more
    # right-votes than the avg of all left votes (+ a 20% margin)
    left  = (poll.value for poll in sorted when poll.name in leftists)
    right = (poll.value for poll in sorted when poll.name not in leftists)
    return parties['anyone'] if avg(left) >= sum(right) * 1.2

    # otherwise, choose the first leftist candidate
    for obj in sorted
      return parties[obj.name] if obj.name in leftists

  render: ->
    <div className="ridings">
      {if @props.riding
        [
          @helmet()
          @share()
          @reco()
          @chart()
          @attribution()
        ]
      else
        @spinner()
      }
    </div>

  helmet: ->
    { t } = @props
    <Helmet key="helmet">
      <meta name="description" content={t 'A strategic voting tool for the 2019 Canadian federal election'} />
      <meta property="og:description" content={t 'A strategic voting tool for the 2019 Canadian federal election'} />
    </Helmet>

  share: ->
    { t } = @props
    url = window.location.href
    <div className="share" key="share">
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
        subject={"VoteWell: #{t 'A strategic voting tool for the 2019 Canadian federal election'}"}
      >
        <EmailIcon size={32} round={true}/>
      </EmailShareButton>
    </div>

  spinner: ->
    <div className="spinner">
      <Spinner className="ball-triangle-path"/>
    </div>

  reco: ->
    { t } = @props
    <div className="reco" key="reco">
      <h1>
        {t 'A strategic vote in'}
      </h1>
      <div className="riding-selector">
        <ReactSelect
          style={{width: 350}}
          clearable={false}
          value={@props.riding}
          options={(label: poll.riding, value: poll.riding, group: poll.province for poll in @props.polls)}
          onChange={@selectRiding}
          autoBlur={probablyMobile}
        />
        <div className="locator">
          {<Spinner name="ball-scale-ripple-multiple" /> if @props.locating}
          <Marker
            className="map-marker"
            onClick={@props.autoLocate}
          />
        </div>
      </div>
      {if @bestOption().name is 'Anyone'
        <h1>
          {t 'is not necessary!'}
          <br/>
          {t 'Please vote for your preferred candidate.'}
        </h1>
      else
        <h1>
          {t 'is a vote for'}
        </h1>
      }
      <img src={@bestOption().img} alt={"#{@bestOption().name}"}/>
    </div>

  chart: ->
    <div className="chart" key="chart">
      <Chart data={@pollData()} height={150}/>
    </div>

  attribution: ->
    { t, i18n } = @props
    <div className="attribution" key="attribution">
      <a href={t "votelink"} style={{color:'black'}}>
        {t "Where do I vote?"}
      </a>
      <span>
        {t "Sources"}:
      </span>
      <a href="https://www.calculatedpolitics.com/project/2019-canada-election/">
        {t "Projections"}
      </a>
      <a href="https://open.canada.ca/data/en/dataset/737be5ea-27cf-48a3-91d6-e835f11834b0">
        {t "Maps"}
      </a>
      <a href="https://github.com/kieran/votewell">
        {t "Code"}
      </a>
      {if (i18n.language or navigator.language or 'en').match /^en/
        <a onClick={=>@setLang 'fr'}>Français</a>
      else
        <a onClick={=>@setLang 'en'}>English</a>
      }
    </div>
