import React  from "react"
import cx     from "classnames"

import './styles'

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
      className={cx 'Chart', @state}
      onClick={@touchHover}
    >
      {for {name, value, party} in @props.data
        <div
          className="bar #{name}"
          key={name}
          title={party.name}
          data-percent={"#{value}%"}
          style={height: "#{value}%", width: "#{width}%"}
        />
      }
    </div>
