import React  from "react"
import cx     from "classnames"

import './styles.sass'

export default \
class Qna extends React.Component
  constructor: ->
    super arguments...
    @state =
      open: false

  toggle: =>
    @setState open: not @state.open

  render: ->
    <div
      className={cx "Qna", @state}
    >
      <div className="question" onClick={@toggle}>
        <h2>{@props.question}</h2>
      </div>
      <div className="answer">
        {@props.children}
      </div>
    </div>
