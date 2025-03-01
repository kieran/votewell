import React  from "react"
import cx     from "classnames"
import { parties, progressives, cons } from "/election"

import './styles'

chart_order = Array.from new Set [cons..., progressives..., Object.keys(parties)...]

export default \
class Chart extends React.Component
  constructor: ->
    super arguments...
    @state =
      hover: false

  touchHover: =>
    @setState hover: not @state.hover

  render: ->
    <div
      className={cx 'Chart', @state}
      onClick={@touchHover}
    >
      {@bar @props.data[party] for party in chart_order when @props.data[party]?}
    </div>

  bar: ({name, proj, moe, incumbent})=>
    return null unless name
    width = 100 / (Object.values(@props.data).length + 1)
    party = parties[name]
    proj = proj.toFixed(0) if proj > 5
    <div
      className="bar #{name}"
      key={name}
      title={"#{party?.name} #{if incumbent then '(incumbent)' else ''}"}
      data-projection={proj}
      data-moe={moe}
      style={height: "#{proj}%", width: "#{width}%"}
    />
