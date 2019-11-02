import React    from "react"
import Qna      from '/components/qna'

export default \
class Faq extends React.Component
  render: ->
    <section key='faq' className='faq'>

      <Qna question="Beth yw hyn?">
        <p>Mae sawl plaid yn y DU â gwleidyddiaeth chwith, gan gynnwys bod yn erbyn Brexit caled, tra bod y bleidlais ar y dde yn llawer mwy cydlynol. Mae hyn yn aml yn achosi "pleidlais hollt" ymhlith pleidleiswyr blaengar, gan roi‘r mwyafrifoedd cynrychioliadol dros ben yn y senedd.</p>
        <p>Er mwyn "rhannu'r" bleidlais, mae‘r offeryn hwn yn dweud wrthych a oes angen pleidleisio tactegol yn eich etholaeth, ac os felly, pa blaid yw‘r prif ddewis.</p>
      </Qna>

      <Qna question="Beth yw pleidleisio tactegol?">
        <p>Yn y bôn, fersiwn â llaw o‘r Bleidlais Amgen yw pleidleisio tactegol, lle mae‘ch pleidlais yn cyfrif tuag at eich dewis gorau a allai ennill.</p>
        <p>Byddai systemau pleidleisio cyfrannol fel y rhai a ddefnyddir yn etholiadau seneddau datganoledig yr Alban, Cymru a Gogledd Iwerddon, ac yn Senedd Ewrop yn cael cynrychiolaeth yn adlewyrchu‘r bleidlais yn awtomatig, gan wneud yr offeryn hwn yn ddarfodedig.</p>
      </Qna>

      <Qna question="A oes angen i mi gofrestru i bleidleisio?">
        <p>Ydw. Os nad ydych wedi pleidleisio yn eich cyfeiriad cyfredol o‘r blaen, bydd angen i chi gofrestru yma erbyn Tachwedd 26 am hanner nos.</p>
      </Qna>

      <Qna question="Beth os ydw i am i‘r Ceidwadwyr ennill?">
        <p>Fe ddylech chi bleidleisio Ceidwadwyr! Gan nad oes rhaniad sylweddol ar y dde, nid oes angen yr offeryn hwn.</p>
        <p>Diolch i chi am gymryd rhan yn ein dyletswydd ddinesig a rennir.</p>
      </Qna>

      <Qna question="Beth yw eich ffynonellau?">
        <p>Rydym yn defnyddio data taflunio a gyhoeddwyd gan y bobl dda yn Electoral Calculus</p>
        <p>Cyhoeddir ffiniau etholaeth gan data.gov.uk.</p>
      </Qna>

      <Qna question="Pwy wyt ti?">
        <p>Kieran Huggins ydw i, datblygwr meddalwedd yn Toronto, Canada.</p>
        <p>Er fy mod yn amlwg â gwleidyddiaeth chwith, nid wyf yn gysylltiedig ag unrhyw blaid wleidyddol.</p>
        <p>Diolch yn arbennig i Jesse Feld am ddarparu enw parth a llwyth o wybodaeth wleidyddol leol amhrisiadwy.</p>
      </Qna>

    </section>
