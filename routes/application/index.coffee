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
import Chart    from '/components/chart'
import Logo     from '/assets/votewell.anim.svg'

import FacebookShareButton  from 'react-share/es/FacebookShareButton'
import TwitterShareButton   from 'react-share/es/TwitterShareButton'
import RedditShareButton    from 'react-share/es/RedditShareButton'
import EmailShareButton     from 'react-share/es/EmailShareButton'
import Facebook from 'react-icons/lib/fa/facebook'
import Twitter  from 'react-icons/lib/fa/twitter'
import Reddit   from 'react-icons/lib/fa/reddit-alien'
import Envelope from 'react-icons/lib/fa/envelope'

import faqs from '/election/faq'
import { languages } from '/election/locales'

sum = (arr=[])-> arr.reduce ((a,b)-> a+b), 0
avg = (arr=[])-> sum(arr) / arr.length
top_2 = (arr=[])-> arr.sort((a,b)->a-b); arr.reverse(); arr[0...2]
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
      gtag 'event', "riding-select", event_category: 'engagement', event_label: riding
      @props.setRiding riding

  lang: =>
    @props.i18n.language or navigator.language or 'en'

  setLang: (lang)=>
    @props.i18n.changeLanguage lang

  pollData: =>
    polls = @pollsFor @props.riding
    (name: key, value: polls[key], party: party for key, party of @props.parties when polls[key])

  leftists: =>
    leftists = (key for key, val of @props.parties when val.leans is 'left')
    return [ leftists..., 'other' ] if @props.riding is 'Vancouver Granville' # JWR
    return [ leftists..., 'other' ] if @props.riding is 'Markham—Stouffville' # Philpott
    leftists

  bestOption: =>
    sorted = sortBy(@pollData(), 'value').reverse()

    # vote strategically if there are more
    # right votes than the avg of the
    # leading two left votes (+ a 20% margin, for safety)
    left  = (poll.value for poll in sorted when poll.name in @leftists())
    right = (poll.value for poll in sorted when poll.name not in @leftists())
    return @props.parties['anyone'] if avg(top_2(left)) >= sum(right) * 1.2

    # otherwise, choose the first leftist candidate
    for obj in sorted
      return @props.parties[obj.name] if obj.name in @leftists()

  electionPast: =>
    (new Date).getTime() > (new Date @props.date).getTime() + 86400 * 1000

  render: ->
    <div className="ridings">
      {if @props.riding
        [
          @header()
          @main()
          @faq()
          @footer()
        ]
      else
        <div className="spinner">
          <Logo/>
        </div>
      }
    </div>

  header: ->
    <header key='header'>
      <Logo/>
    </header>

  notice: ->
    return null unless @electionPast()
    <div className="notice">
      This election is now over. The data visible here represents the final polling numbers.
    </div>

  main: ->
    <main key='main'>
      {@selector()}
      {@reco()}
      {@chart()}
    </main>

  faq: ->
    Faq = faqs[@lang()] or faqs.en
    <Faq key='faq'/>

  footer: ->
    <footer key='footer'>
      <div className="top">
        <Logo/>
        {@share()}
      </div>
      <div className="bottom">
        {@links()}
        {@languageSelector()}
      </div>
    </footer>

  share: ->
    { t } = @props
    url = window.location.href
    <div className="share" key="share">
      <EmailShareButton
        url={url}
        subject={"VoteWell: #{t 'description'}"}
      >
        <Envelope/>
      </EmailShareButton>
      <TwitterShareButton url={url}>
        <Twitter/>
      </TwitterShareButton>
      <FacebookShareButton url={url}>
        <Facebook/>
      </FacebookShareButton>
      <RedditShareButton url={url}>
        <Reddit/>
      </RedditShareButton>
    </div>

  selector: ->
    <div className="riding-selector">
      <ReactSelect
        style={{width: Math.min( 650, window.innerWidth * 0.9 )}}
        clearable={false}
        value={@props.riding}
        options={(label: poll.riding.replace(/—/g,' / '), value: poll.riding for poll in @props.polls)}
        onChange={@selectRiding}
        autoBlur={probablyMobile}
      />
    </div>

  reco: ->
    party = @bestOption()
    <div className="reco" key="reco">
      {@notice()}
      {if party.name is 'Anyone'
        @anyone()
      else
        @party party
      }
    </div>

  anyone: ->
    { t } = @props
    <div className="result-text">
      <small>
        {t 'A strategic vote in your riding'}
        <span className='br'> </span>
        {t 'is not necessary'}
      </small>
      {t 'Please vote for your preferred candidate.'}
    </div>

  party: (party)->
    { t } = @props
    {name, img} = party
    <div className="result-text">
      <small>
        {t 'A strategic vote in your riding'}
        <span className='br'> </span>
        {t 'is a vote for'}
      </small>
      {if img
        <img
          className="party"
          src={img}
          alt={"#{name}"}
        />
      else
        <h2>{name}</h2>
      }
    </div>

  chart: ->
    <div className="chart" key="chart">
      <Chart data={@pollData()}/>
    </div>

  links: ->
    { t } = @props
    <div className="links" key="links">
      <a href={t 'votelink'}>
        {t 'Where do I vote?'}
      </a>
      <a href={t 'datalink'}>
        {t 'Projections'}
      </a>
      <a href={t 'maplink'}>
        {t 'Maps'}
      </a>
      <a href="https://github.com/kieran/votewell">
        {t 'Code'}
      </a>
    </div>

  languageSelector: ->
    <div className="languageSelector" key="languageSelector">
      {(for code, name of languages when @lang().indexOf(code) isnt 0
        <a key={code} onClick={@setLang.bind @, code}>{name}</a>
      )}
    </div>
