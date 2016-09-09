React = require 'react'
ReactDOM = require 'react-dom'
App = require './components/app'

element = React.createElement(App)
ReactDOM.render(element, document.getElementById('app'))
