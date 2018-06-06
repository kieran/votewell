import './styles'

# bundle assets - full URL in html
import './assets/votewell.png'
import './assets/favicon-128x128.png'
import './assets/favicon-64x64.png'
import './assets/favicon-32x32.png'
import './assets/favicon-16x16.png'

# react
import React        from "react"
import { render }   from "react-dom"

# redux
import { Provider } from 'react-redux'
import store from '/store'

window.store = store

# routes
import Application  from '/routes/application'

class App extends React.Component
  render: ->
    <Provider store={store}>
      <Application/>
    </Provider>

render <App />, document.getElementById "Application"
