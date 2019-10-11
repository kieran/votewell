import React  from "react"
import cx     from "classnames"

import './styles.sass'

export default \
class Chart extends React.Component
  constructor: ->
    super arguments...
    @state =
      hover: false

  touchHover: =>
    @setState hover: not @state.hover

  render: ->
    width = 100 / (@props.data.length + 1)
    <div
      className="Chart #{cx @state}"
      onClick={@touchHover}
    >
      {for {name, value} in @props.data
        <div
          className="bar #{name}"
          key={name}
          title={"#{value}%"}
          style={height: "#{value}%", width: "#{width}%"}
        />
      }
    </div>
