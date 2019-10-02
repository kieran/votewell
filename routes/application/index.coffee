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
import Logo     from '/assets/votewell.anim.svg'

import {
  FacebookShareButton
  TwitterShareButton
  RedditShareButton
  EmailShareButton
} from 'react-share'

import Facebook from 'react-icons/lib/fa/facebook-square'
import Twitter  from 'react-icons/lib/fa/twitter'
import Reddit   from 'react-icons/lib/fa/reddit-alien'
import Envelope from 'react-icons/lib/fa/envelope'

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
  anyone:
    name: "Anyone"

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

  main: ->
    <main key='main'>
      {@selector()}
      {@reco()}
      {@chart()}
    </main>

  faq: ->
    <section key='faq' className='faq'>
      <h2>What is this?</h2>
      <p>There are 3 national parties in Canada with leftist politics, and only one that is right-leaning. This often causes a "split vote" among leftist voters, giving the right an over-representation of electoral seats.</p>
      <p>To "un-split" the vote, this tool will tell you if strategic voting is necessary in your riding, and if so, which party is the leading choice.</p>
      <h2>What is strategic voting?</h2>
      <p>Stragtegic voting is essentially a manual version of a <a href="https://en.wikipedia.org/wiki/Ranked_voting">ranked ballot</a>, where your vote counts towards your top choice that could win.</p>
      <p><a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">Electoral reform</a>, although promised in the 2015 federal election, will do this automatically, making this tool obsolete.</p>
      <h2>What if I want the Conservatives to win?</h2>
      <p>You should vote Conservative! Since there's no split on the right, this tool is not necessary. Thank you for participating in our shared civic duty.</p>
      <h2>Who are you?</h2>
      <p>I'm <a href="https://kieran.ca">Kieran Huggins</a> from Toronto, Canada. While I clearly have leftist politics, I am not affiliated with any political party.</p>
    </section>

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
        <Facebook/>
      </FacebookShareButton>
      <TwitterShareButton url={url}>
        <Twitter/>
      </TwitterShareButton>
      <RedditShareButton url={url}>
        <Reddit/>
      </RedditShareButton>
      <EmailShareButton
        url={url}
        subject={"VoteWell: #{t 'A strategic voting tool for the 2019 Canadian federal election'}"}
      >
        <Envelope/>
      </EmailShareButton>
    </div>

  spinner: ->
    <div className="spinner">
      <Spinner className="ball-triangle-path"/>
    </div>

  selector: ->
    <div className="riding-selector">
      <ReactSelect
        style={{width: Math.min( 650, window.innerWidth * 0.9 )}}
        clearable={false}
        value={@props.riding}
        options={(label: poll.riding.replace(/—/g,' / '), value: poll.riding, group: poll.province for poll in @props.polls)}
        onChange={@selectRiding}
        autoBlur={probablyMobile}
      />
    </div>

  reco: ->
    party = @bestOption()
    <div className="reco" key="reco">
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
    <div className="result-text">
      <small>
        {t 'A strategic vote in your riding'}
        <span className='br'> </span>
        {t 'is a vote for'}
      </small>
      <img
        className="party"
        src={party.img}
        alt={"#{party.name}"}
      />
    </div>

  chart: ->
    <div className="chart" key="chart">
      <Chart
        data={@pollData()}
        height={150}
      />
    </div>

  links: ->
    { t } = @props
    <div className="links" key="links">
      <a href={t "votelink"}>
        {t "Where do I vote?"}
      </a>
      <a href="https://calculatedpolitics.ca/2019-canadian-federal-election/">
        {t "Projections"}
      </a>
      <a href="https://open.canada.ca/data/en/dataset/737be5ea-27cf-48a3-91d6-e835f11834b0">
        {t "Maps"}
      </a>
      <a href="https://github.com/kieran/votewell">
        {t "Code"}
      </a>
    </div>

  languageSelector: ->
    { i18n } = @props
    <div className="lamnguageSelector" key="lamnguageSelector">
      {if (i18n.language or navigator.language or 'en').match /^en/
        <a onClick={=>@setLang 'fr'}>Français</a>
      else
        <a onClick={=>@setLang 'en'}>English</a>
      }
    </div>
