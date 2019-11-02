import React    from "react"
import Qna      from '/components/qna'

export default \
class Faq extends React.Component
  render: ->
    <section key='faq' className='faq'>

      <Qna question="What is this?">
        <p>
          There are several parties in the UK with leftist politics, including being against a hard Brexit, while the vote on the right is far more cohesive. This often causes a "split vote" among progressive voters, giving the right
          {' '}<a href="https://www.youtube.com/watch?v=r9rGX91rq5I">over-representative majorities in parliament.</a>
        </p>
        <p>To "un-split" the vote, this tool tells you if tactical voting is necessary in your constituency, and if so, which party is the leading choice.</p>
      </Qna>

      <Qna question="What is tactical voting?">
        <p>Tactical voting is essentially a manual version of the <a href="https://en.wikipedia.org/wiki/Instant-runoff_voting">Alternative Vote</a>, where your vote counts towards your top choice that could win.</p>
        <p>
          Proportional voting systems such as those used in the elections of the
          {' '}<a href="https://en.wikipedia.org/wiki/Next_Scottish_Parliament_election#Election_system,_seats,_and_regions">
            Scottish
          </a>,{' '}
          {' '}<a href="https://en.wikipedia.org/wiki/Next_National_Assembly_for_Wales_election#Electoral_system">
            Welsh
          </a>{' '}
          and
          {' '}<a href="https://en.wikipedia.org/wiki/Single_transferable_vote">
            Northern Irish
          </a>{' '}
          devolved parliaments, and in the
          {' '}<a href="https://en.wikipedia.org/wiki/2019_European_Parliament_election_in_the_United_Kingdom#Electoral_method">
            European Parliament
          </a>{' '}
          would automatically have representation reflect the vote, making this tool obsolete.
        </p>
      </Qna>

      <Qna question="How do I register to vote?">
        <p>
          If you haven’t voted at your current address before, you will need to
          {' '}<a href="https://www.gov.uk/register-to-vote">register here</a>{' '}
          by November 26 at midnight.
        </p>
      </Qna>

      <Qna question="What if I want the Conservatives to win?">
        <p>You should vote Conservative! Since there’s no significant split on the right, this tool is not necessary.</p>
        <p>Thank you for participating in our shared civic duty.</p>
      </Qna>

      <Qna question="What are your sources?">
        <p>
          We use projection data published by the good people at
          {' '}
          <a href="https://www.electoralcalculus.co.uk">Electoral Calculus</a>
        </p>
        <p>
          Constituency boundaries are published by
          {' '}
          <a href="https://data.gov.uk/dataset/24c282a1-1330-427e-b154-36ff3bfa5dac/westminster-parliamentary-constituencies-december-2015-generalised-clipped-boundaries-in-great-britain">
            data.gov.uk
          </a>
        </p>
      </Qna>

      <Qna question="Who are you?">
        <p>I’m <a href="https://kieran.ca">Kieran Huggins</a>, a software developer in Toronto, Canada.</p>
        <p>While I clearly have leftist politics, I am not affiliated with any political party.</p>
        <p>Special thanks to <a href="http://jessefeld.com">Jesse Feld</a> for providing the domain name & loads of invaluable local political knowledge.</p>
      </Qna>

    </section>
