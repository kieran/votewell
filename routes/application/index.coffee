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
import Qna      from '/components/qna'
import Logo     from '/assets/votewell.anim.svg'

import CPLogo   from '/assets/cp-light.png'

import FacebookShareButton  from 'react-share/es/FacebookShareButton'
import TwitterShareButton   from 'react-share/es/TwitterShareButton'
import RedditShareButton    from 'react-share/es/RedditShareButton'
import EmailShareButton     from 'react-share/es/EmailShareButton'
import Facebook from 'react-icons/lib/fa/facebook'
import Twitter  from 'react-icons/lib/fa/twitter'
import Reddit   from 'react-icons/lib/fa/reddit-alien'
import Envelope from 'react-icons/lib/fa/envelope'

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
      gtag? 'event', "riding-select", event_category: 'engagement', event_label: riding
      @props.setRiding riding

  isEnglish: ->
    (@props.i18n.language or navigator.language or 'en').match /^en/

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

        <Qna question="What is this?">
          <p>There are 3 national parties in Canada with leftist politics, and only one that is right-leaning. This often causes a "split vote" among leftist voters, giving the right an over-representation of electoral seats.</p>
          <p>To "un-split" the vote, this tool tells you if strategic voting is necessary in your riding, and if so, which party is the leading choice.</p>
        </Qna>

        <Qna question="What is strategic voting?">
          <p>Strategic voting is essentially a manual version of a <a href="https://en.wikipedia.org/wiki/Ranked_voting">ranked ballot</a>, where your vote counts towards your top choice that could win.</p>
          <p><a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">Electoral reform</a>, although promised in the 2015 federal election, will do this automatically, making this tool obsolete.</p>
        </Qna>

        <Qna question="What if I want the Conservatives to win?">
          <p>You should vote Conservative! Since there’s no split on the right, this tool is not necessary.</p>
          <p>Thank you for participating in our shared civic duty.</p>
        </Qna>

        <Qna question="What are your sources?">
          <p>
            Polling data is aggregated by the good people at
            {' '}
            <a className="imglink" href="https://calculatedpolitics.ca/2019-canadian-federal-election/">
              <img className="cp-logo" src={CPLogo} style={{height: '24px'}} alt={"Calculated Politics"} />
            </a>
          </p>
          <blockquote>
            <p>The data you see here represents a projection of likely election outcomes in each riding using statistical methodology based on all publicly available polling data. CalculatedPolitics.ca is not a polling firm itself.</p>
            <p>The accuracy of these projections is dependent upon the overall accuracy of the polling industry and we make no assurances of the polling industry’s accuracy in this or any other election.</p>
          </blockquote>
          <p>
            Riding boundaries are published by{' '}
            <a href="https://open.canada.ca/data/en/dataset/737be5ea-27cf-48a3-91d6-e835f11834b0">
              Elections Canada
            </a>
          </p>
        </Qna>

        <Qna question="Who are you?">
          <p>I’m <a href="https://kieran.ca">Kieran Huggins</a>, a software developer in Toronto, Canada.</p>
          <p>While I clearly have leftist politics, I am not affiliated with any political party.</p>
        </Qna>
      </section>
    else
      <section key='faq' className='faq'>
        <Qna question="Qu'est-ce que c'est que ça?">
          <p>Il y a trois partis politiques de Gauche au Canada et seulement un à Droite. Cela cause souvent une éparpillement des voix de gauche et par contraste, les voix de droite sont plus puissantes.</p>
          <p>Afin d’unifier le vote, cet outil vous informe si un vote utile est nécessaire dans votre circonsription électorale, et, si oui, lequel des partis est en tête.</p>
        </Qna>

        <Qna question="Qu’est-ce q'un vote utile?">
          <p>Un vote utile est une version d’un <a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">vote cumulatif</a>, pour lequel on donne sa voix au parti politique avec la meilleure probabilité de gagner.</p>
          <p><a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">La réforme électorale</a>, bien que promise au cours de l’élection féderale de 2015, devrait accomplir cette tâche automatiquement et rendre cet outil obsolète.</p>
        </Qna>

        <Qna question="...Et si je veux que le parti Conservateur remporte l’élection?">
          <p>Vous devriez donner votre voix au parti Conservateur! Puisque il n’y a pas d’éparpillement des voix à droite, cet outil n’est pas nécessaire.</p>
          <p>Merci d’avoir participé à notre devoir civique commun.</p>
        </Qna>

        <Qna question="Qui êtes-vous?">
          <p>Je m’appelle <a href="https://kieran.ca">Kieran Huggins</a> et je viens de Toronto, Canada.</p>
          <p>Bien que j’ai des tendences gauchistes, je ne suis affilié à aucun parti politique.</p>
        </Qna>
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
