import React    from "react"
import Qna      from '/components/qna'

export default \
class Faq extends React.Component
  render: ->
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
