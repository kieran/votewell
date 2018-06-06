import React        from "react"
import { render }   from "react-dom"

# import './styles'

# components
import {
  ResponsiveContainer
  BarChart
  Bar
  Cell
} from 'recharts'

# routes

class MyBar extends Bar
  render: ->
    console.table @props
    <Bar {@props...}/>


colours =
  pc:     '#2d368c'
  lib:    '#e9243d'
  ndp:    '#ff9900'
  grn:    '#3D9B35'
  other:  '#7030a0'

# import container from './container'

export default \
class Chart extends React.Component
  @defaultProps:
    height: 250

  render: ->
    <ResponsiveContainer width='100%' height={@props.height}>
      <BarChart data={@props.data}>
        <Bar dataKey="value">
          {<Cell className={entry.name} key={entry.name} fill={colours[entry.name]}/> for entry in @props.data}
        </Bar>
      </BarChart>
    </ResponsiveContainer>
