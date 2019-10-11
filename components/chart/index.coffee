import React        from "react"

import './styles.sass'

export default \
class Chart extends React.Component
  constructor: ->
    super arguments...
    @state =
      showPercentages: false

  togglePercentages: =>
    @setState showPercentages: not @state.showPercentages

  render: ->
    width = 100 / (@props.data.length + 1)
    <div
      className="Chart #{if @state.showPercentages then 'hover' else ''}"
      onClick={@togglePercentages}
    >
      {for entry in @props.data
        <div
          className="bar #{entry.name}"
          key={entry.name}
          title={entry.value}
          style={height: "#{entry.value}%", width: "#{width}%"}
        />
      }
    </div>
