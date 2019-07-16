import React        from "react"
import { render }   from "react-dom"
import sortBy       from 'underscore-es/sortBy'
import findIndex    from 'underscore-es/findIndex'
import ReactSelect  from 'react-select'
import {
  withTranslation
} from 'react-i18next'

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

export default \
withTranslation() \
class Application extends React.Component
  pollsFor: (riding)->
    for poll in @props.polls
      return poll if poll.riding is riding
    console.log "couldn't match #{riding} with poll data"

  selectRiding: (evt)=>
    @props.setRiding evt?.target?.value or evt?.value

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
        subject="VoteWell: A strategic voting tool for the 2019 Canadian federal election"
      >
        <EmailIcon size={32} round={true}/>
      </EmailShareButton>
    </div>

  spinner: ->
    <div className="spinner">
      <Spinner className="ball-triangle-path"/>
    </div>

  reco: ->
    <div className="reco" key="reco">
      <h1>A strategic vote in</h1>
      <ReactSelect
        className="riding-selector"
        style={{width: 350}}
        clearable={false}
        value={@props.riding}
        options={(label: poll.riding, value: poll.riding, group: poll.province for poll in @props.polls)}
        onChange={@selectRiding}
      />
      {if @bestOption().name is 'Anyone'
        <h1>is not necessary!<br/>Please vote for your preferred candidate.</h1>
      else
        <h1>is a vote for</h1>
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
      <a href="https://www.elections.ca/content.aspx?section=vot&dir=vote&document=index&lang=e" style={{color:'black'}}>
        {t "Where do I vote?"}
      </a>
      <span>
        Sources:
      </span>
      <a href="https://www.calculatedpolitics.com/project/2019-canada-election/">
        Projections
      </a>
      <a href="https://open.canada.ca/data/en/dataset/737be5ea-27cf-48a3-91d6-e835f11834b0">
        Maps
      </a>
      <a href="https://github.com/kieran/votewell">
        Code
      </a>
      <button onClick={i18n.changeLanguage.bind @, 'en'}>en</button>
      <button onClick={i18n.changeLanguage.bind @, 'fr'}>fr</button>
    </div>
