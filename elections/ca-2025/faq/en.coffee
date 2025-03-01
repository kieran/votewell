import React    from "react"
import Qna      from '/components/qna'

export default \
class Faq extends React.Component
  render: ->
    <>
      <Qna question="What is this?">
        <p>There are 3 national parties in Canada with progressive politics, and only one that is right-leaning. This often causes a "split vote" among progressive voters, giving the right an over-representation of electoral seats.</p>
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
          <a className="imglink" href="https://338canada.com">338 Canada</a>
        </p>
        <blockquote>
          <p>This projection is calculated using a mostly-proportional swing model adjusted with provincial and regional <a href="https://338canada.com/polls.htm" target="_blank">polls</a> conducted by professional pollsters. </p>
          <p>This is <i>not</i> a poll, but a projection based on polls.</p>
          <p>The 338Canada model also takes into account electoral history and other data.</p>
          <p>Read more on 338Canada's methodology <a href="https://338canada.blogspot.com/2018/11/welcome-to-338canada.html#metho" target="_blank">here</a>.</p>
        </blockquote>
        <p>
          Riding boundaries are published by{' '}
          <a href="https://open.canada.ca/data/en/dataset/737be5ea-27cf-48a3-91d6-e835f11834b0">
            Elections Canada
          </a>
        </p>
      </Qna>

      <Qna question="Who are you?">
        <p>I’m <a href="https://kieran.ca">Kieran Huggins</a>, a software developer in Victoria, Canada.</p>
        <p>While I clearly have leftist politics, I am not affiliated with any political party.</p>
        <p>Design by <a href="https://arthurchayka.com">Arthur Chayka</a></p>
      </Qna>

      <Qna question="Why don't you solicit donations?">
        <p>Hosting this website <strong>costs about $1 per election, <em>total</em>.</strong> It's a cost I'm more than happy to cover personally.</p>
        <p>Please be mindful when companies with similar websites ask you for a donation to "keep the lights on".</p>
      </Qna>
    </>
