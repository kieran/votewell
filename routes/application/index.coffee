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
import Chart    from '/components/chart'
import Logo     from '/assets/votewell.anim.svg'

import {
  FacebookShareButton
  TwitterShareButton
  RedditShareButton
  EmailShareButton
} from 'react-share'

import Facebook from 'react-icons/lib/fa/facebook'
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
top_2 = (arr=[])-> arr.sort(); arr.reverse(); arr[0...2]
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

  isEnglish: ->
    (@props.i18n.language or navigator.language or 'en').match /^en/

  setLang: (lang)=>
    @props.i18n.changeLanguage lang

  pollData: =>
    polls = @pollsFor @props.riding
    (name: key, value: val for key, val of polls when val and key in 'pc lib ndp grn bloc other'.split ' ')

  bestOption: =>
    sorted = sortBy(@pollData(), 'value').reverse()

    # vote strategically if there are more
    # right votes than the avg of the
    # leading two left votes (+ a 20% margin, for safety)
    left  = (poll.value for poll in sorted when poll.name in leftists)
    right = (poll.value for poll in sorted when poll.name not in leftists)
    return parties['anyone'] if avg(top_2(left)) >= sum(right) * 1.2

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
    if @isEnglish()
      <section key='faq' className='faq'>
        <h2>What is this?</h2>
        <p>There are 3 national parties in Canada with leftist politics, and only one that is right-leaning. This often causes a "split vote" among leftist voters, giving the right an over-representation of electoral seats.</p>
        <p>To "un-split" the vote, this tool tells you if strategic voting is necessary in your riding, and if so, which party is the leading choice.</p>

        <h2>What is strategic voting?</h2>
        <p>Strategic voting is essentially a manual version of a <a href="https://en.wikipedia.org/wiki/Ranked_voting">ranked ballot</a>, where your vote counts towards your top choice that could win.</p>
        <p><a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">Electoral reform</a>, although promised in the 2015 federal election, will do this automatically, making this tool obsolete.</p>

        <h2>What if I want the Conservatives to win?</h2>
        <p>You should vote Conservative! Since there's no split on the right, this tool is not necessary. Thank you for participating in our shared civic duty.</p>

        <h2>Who are you?</h2>
        <p>I'm <a href="https://kieran.ca">Kieran Huggins</a>, a software developer in Toronto, Canada. While I clearly have leftist politics, I am not affiliated with any political party.</p>
      </section>
    else
      <section key='faq' className='faq'>
        <h2>Qu'est-ce que c'est que ça?</h2>
        <p>Il ya a trois partis politiques de Gauche au Canada, et il y a seulement un de Droite. Cela cause souvent une émiettement des voix gauches et par contraste, les voix de Droite sont plus puissantes.</p>
        <p>Afin de unifier le vote, cet outil vous informe si un vote utile est nécessaire dans votre circonsription électorale, et, si oui, lequel des parties est en tête.</p>

        <h2>Qu’est-ce c’est un vote utile?</h2>
        <p>Un vote utile est une version d’un <a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">vote cumulatif</a>, dans laquelle on donne la voix au parti politique avec la meilleure probabilité de gagner.</p>
        <p><a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">La réforme électorale</a>, quoique promît dans l’élection féderale de 2015, va faire ce tâche automatiquement et va rendre cet outil obsolète.</p>

        <h2>...Et si je veux que le parti Conservateur remporte l’élection?</h2>
        <p>Vous devriez donner votre voix au parti Conservateur! Puisque il n’y a pas d’émiettement des voix droites, cet outil n’est pas nécessaire. Merci d’avoir participer à notre devoir civique en commun.</p>

        <h2>Qui êtes-vous?</h2>
        <p>Je m’appelle <a href="https://kieran.ca">Kieran Huggins</a> et je viens de Toronto, Canada. Bien que j’aie des tendences gauchistes, je ne suis pas affilié à aucun parti politique.</p>
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
      <EmailShareButton
        url={url}
        subject={"VoteWell: #{t 'A strategic voting tool for the 2019 Canadian federal election'}"}
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
      <Chart data={@pollData()}/>
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
    <div className="lamnguageSelector" key="lamnguageSelector">
      {if @isEnglish()
        <a onClick={=>@setLang 'fr'}>Français</a>
      else
        <a onClick={=>@setLang 'en'}>English</a>
      }
    </div>
