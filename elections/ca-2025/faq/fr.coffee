import React    from "react"
import Qna      from '/components/qna'

export default \
class Faq extends React.Component
  render: ->
    <>

      <Qna question="Mais qu'est-ce que ce site?">
        <p>Il y existe trois partis politiques majeurs de gauche au Canada et seulement un à droite. Cela crée souvent une division des voix favorisant la gauche et à l'opposé, une surreprésentation des sièges conservateurs.</p>
        <p>Afin d’unifier le vote, cet outil vous informe si un vote stratégique est nécessaire dans votre circonscription électorale, et, si oui, lequel des partis est en tête.</p>
      </Qna>

      <Qna question="Qu’est-ce qu'un vote stratégique?">
        <p>Un vote stratégique est une version d’un <a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">vote cumulatif</a>, pour lequel on donne sa voix au parti politique avec la meilleure probabilité de gagner.</p>
        <p><a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">La réforme électorale</a>, bien que promise lors de l’élection féderale de 2015, devrait éventuellement accomplir cette tâche automatiquement et rendre cet outil obsolète.</p>
      </Qna>

      <Qna question="...Et si je veux que le parti Conservateur remporte l’élection?">
        <p>Vous devriez alors voter pour le parti Conservateur! Puisque il n’y a pas de division des voix à droite, cet outil ne vous est pas nécessaire.</p>
        <p>Merci de participer à notre devoir civique commun.</p>
      </Qna>

      <Qna question="Qui êtes-vous?">
        <p>Je m’appelle <a href="https://kieran.ca">Kieran Huggins</a> et je suis de Victoria en Colombie-Brittanique.</p>
        <p>Bien que j’aie des tendances gauchistes, je ne suis affilié à aucun parti politique.</p>
      </Qna>

    </>
