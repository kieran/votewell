import React    from "react"
import Qna      from '/components/qna'
import CPLogo   from '../cp-light.png'

export default \
class Faq extends React.Component
  render: ->
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
          <a className="imglink" href="https://calculatedpolitics.ca/projection/canadian-federal-election/">
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
