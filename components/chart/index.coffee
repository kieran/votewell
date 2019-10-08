import React        from "react"

# components
import ResponsiveContainer from 'recharts/es6/component/ResponsiveContainer'
import BarChart from 'recharts/es6/chart/BarChart'
import Bar      from 'recharts/es6/cartesian/Bar'
import Cell     from 'recharts/es6/component/Cell'
import Tooltip  from 'recharts/es6/component/Tooltip'

class MyBar extends Bar
  render: ->
    <Bar {@props...}/>

class MyTooltip extends React.Component
  render: ->
    { active, payload, label } = @props
    return null unless active
    {value} = payload[0]
    <div className="my-tooltip">{value}%</div>

colours =
  pc:     '#2d368c'
  lib:    '#e9243d'
  ndp:    '#f99e29'
  grn:    '#3D9B35' # <-- official colour, logo is #348c35 :-/
  bloc:   '#00A8ED'
  other:  '#aaaaaa'

export default \
class Chart extends React.Component
  @defaultProps:
    height: 250

  render: ->
    <ResponsiveContainer width='100%' height={@props.height}>
      <BarChart data={@props.data}>
        <Tooltip
          cursor={false}
          content={<MyTooltip/>}
        />
        <Bar dataKey="value">
          {<Cell className={entry.name} key={entry.name} fill={colours[entry.name]}/> for entry in @props.data}
        </Bar>
      </BarChart>
    </ResponsiveContainer>
