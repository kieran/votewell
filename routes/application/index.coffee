import React        from 'react'
import sortBy       from 'underscore-es/sortBy'
import findIndex    from 'underscore-es/findIndex'
import { parties, progressives, date } from "/election"

import 'core-js/actual/array/to-sorted'

import ReactSelect  from 'react-select'
import {
  withTranslation
} from 'react-i18next'

import 'react-select/dist/react-select.css'
import './styles.sass'

# components
import Chart    from '/components/chart'
import Qna      from '/components/qna'
import Logo     from 'jsx:/assets/votewell.anim.svg'

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
avg = (arr=[])-> 1 / arr.length * sum arr
top_2 = (arr=[])-> arr.sort((a,b)->b-a)[0...2]
rms = (arr=[])-> Math.sqrt 1/arr.length * sum arr.map (v)-> v*v
probablyMobile = matchMedia?('(orientation: portrait) and (max-width: 600px)')?.matches or false

export default \
withTranslation() \
class Application extends React.Component
  pollsFor: (riding)->
    try
      {riding, incumbent, ...rest} = @props.polls.find (poll)-> poll.riding is riding
      rest
    catch
      err = "couldn't match #{riding} with poll data"
      Sentry?.captureMessage? err
      console.log err

  selectRiding: (evt)=>
    if riding = evt?.target?.value or evt?.value
      gtag 'event', "riding-select", event_category: 'engagement', event_label: riding
      @props.setRiding riding

  lang: =>
    @props.i18n.language or navigator.language or 'en'

  setLang: (lang)=>
    @props.i18n.changeLanguage lang


  progressivesFor: (riding)=>
    ret = progressives
    # this is where we may override polling data
    # e.g. when a candidate drops out, etc
    # ret.push 'ind' if riding is 'Hamilton Centre'
    ret

  bestOptionFor: (riding)=>
    progs = @progressivesFor riding

    sorted = \
      Object.values @pollsFor riding
      # prefer the incumbent in a tie
      .toSorted (a,b)-> +b.incumbent - +a.incumbent
      # prefer leading larty
      .toSorted (a,b)-> b.proj - a.proj

    leftists = (a for a in sorted when a.name in progs)
    righties = (a for a in sorted when a.name not in progs)

    # vote strategically iff the leading right party
    # has over 90% the support of the RMS of
    # the two leading leftist parties
    left_weight  = rms top_2 (poll.proj for poll in leftists)
    right_weight = Math.max (poll.proj for poll in righties)...
    strategy_required = right_weight > 0.9 * left_weight

    # strategic vote not needed? vote for your preferred candidate
    return 'anyone' unless strategy_required

    # otherwise, choose the first leftist candidate
    leftists[0].name

  electionPast: =>
    (new Date).getTime() > (new Date date).getTime() + 86400 * 1000

  render: ->
    { locating } = @props
    <div className="ridings">
      {[
        @header()
        @main()   unless locating
        @faq()    unless locating
        @footer() unless locating
      ]}
    </div>

  header: ->
    <header key='header'>
      <Logo />
    </header>

  notice: (msg)->
    <div className="notice">{msg}</div>

  notices: ->
    electionOver  = @notice <>
      This election is now over. The data visible here represents the final polling numbers.
      <br/>
      <br/>
      Votewell will return for the next Canadian election.
    </>
    droppedOut    = (name, party)=> @notice "#{name} (#{party}) has discontinued their campaign, though their name remains on the ballot."

    [
      electionOver  if @electionPast()
      # droppedOut('Candidate Name', 'Party Name') if @props.riding is 'riding-name'
    ]

  main: ->
    return null unless @props.riding
    <main key='main'>
      {@selector()}
      {@reco()}
      {@chart()}
    </main>

  faq: ->
    Faq = faqs[@lang()] or faqs.en
    <section key='faq' className='faq'>
      <Faq key='faq'/>
      <Qna question="Can you show me a list of all your recommendations?">
        <p>These recommendations may change as new polling data is published:</p>
        {@list()}
      </Qna>
    </section>

  footer: ->
    <footer key='footer'>
      <div className="top">
        <Logo />
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
    party = parties[@bestOptionFor @props.riding]
    <div className="reco" key="reco">
      {@notices()}
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
      <Chart data={@pollsFor @props.riding}/>
    </div>

  list: ->
    <div className="list" key="list">
      <table>
        <thead>
          <tr>
            <th>Riding</th>
            <th>Suggestion</th>
          </tr>
        </thead>
        <tbody>
          {for poll in @props.polls
            opt = @bestOptionFor poll.riding
            riding = poll.riding.replace /—/g,' / '
            reco = parties[opt]

            <tr key={riding}>
              <td>{riding}</td>
              <td className={"#{opt} #{reco?.name}"}>{reco?.name}</td>
            </tr>
          }
        </tbody>
      </table>
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
