import React    from "react"
import Qna      from '/components/qna'

export default \
class Faq extends React.Component
  render: ->
    <>
      <Qna question="Qu’est-ce que c’est que ça ?">
        <p>Il y a deux grands partis provinciaux en C.-B. qui ont une orientation politique de gauche. Cela provoque souvent un éparpillement des voix chez les électeurs, ce qui donne au Parti conservateur une surreprésentation des sièges à l’Assemblée législative.</p>
        <p>Afin d’unifier le vote, cet outil vous indique s’il est nécessaire de faire un vote stratégique dans votre circonscription électorale, et, le cas échéant, quel parti a le plus de chances de gagner.</p>
      </Qna>

      <Qna question="Qu’est-ce qu’un vote stratégique ?">
        <p>Un vote stratégique est essentiellement une version manuelle d’un <a href="https://fr.wikipedia.org/wiki/Vote_pr%C3%A9f%C3%A9rentiel">vote préférentiel</a>, où votre vote compte pour votre premier choix qui a une chance de l’emporter.</p>
        <p><a href="https://en.wikipedia.org/wiki/Electoral_reform#Canada">La réforme électorale</a>, promise lors de l’élection fédérale de 2015, permettrait d’automatiser ce processus et rendrait cet outil désuet.</p>
      </Qna>

      <Qna question="Et si je veux que le Parti conservateur l’emporte ?">
        <p>Vous devriez voter pour le Parti conservateur !</p>
        <p>Merci de participer à notre devoir civique commun.</p>
      </Qna>

      <Qna question="Quelles sont vos sources ?">
        <p>
          Les données de sondage sont agrégées par les bons gens de
          {' '}
          <a className="imglink" href="https://338canada.com">338 Canada</a>
        </p>
        <blockquote>
          <p>Cette projection est calculée à l’aide d’un modèle de bascule principalement proportionnel, ajusté en fonction des <a href="https://338canada.com/polls.htm" target="_blank" rel="noopener noreferrer">sondages</a> provinciaux et régionaux réalisés par des sondeurs professionnels.</p>
          <p>Il ne s’agit <i>pas</i> d’un sondage, mais d’une projection basée sur des sondages.</p>
          <p>Le modèle 338Canada tient également compte de l’histoire électorale et d’autres données.</p>
          <p>Pour en savoir plus sur la méthodologie de 338Canada, cliquez <a href="https://338canada.blogspot.com/2018/11/welcome-to-338canada.html#metho" target="_blank" rel="noopener noreferrer">ici</a>.</p>
        </blockquote>
        <p>
          Les limites des circonscriptions sont publiées par{' '}
          <a href="https://open.canada.ca/data/en/dataset/737be5ea-27cf-48a3-91d6-e835f11834b0">
            Élections Canada
          </a>
        </p>
      </Qna>

      <Qna question="Qui êtes-vous ?">
        <p>Je m’appelle <a href="https://kieran.ca">Kieran Huggins</a>, un développeur de logiciels à Victoria, au Canada.</p>
        <p>Bien que j’aie clairement des tendances de gauche, je ne suis affilié à aucun parti politique.</p>
        <p>Conception graphique par <a href="https://arthurchayka.com">Arthur Chayka</a></p>
      </Qna>

      <Qna question="Pourquoi ne sollicitez-vous pas de dons ?">
        <p>L’hébergement de ce site Web <strong>coûte environ 1 $ par élection, <em>au total</em>.</strong> C’est un coût que je suis plus qu’heureux de couvrir personnellement.</p>
        <p>Veuillez faire preuve de prudence lorsque des entreprises ayant des sites Web similaires vous demandent un don pour « maintenir les lumières allumées ».</p>
      </Qna>
    </>
