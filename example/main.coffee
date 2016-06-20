React = require 'react'
ReactDOM = require 'react-dom'
App = require './components/app'

# TODO: support as peer dependency
keymap = require './keymap'
ShortcutsManager = require 'react-shortcuts'
shortcutManager = new ShortcutsManager(keymap)

element = React.createElement(App, { shortcuts: shortcutManager })
ReactDOM.render(element, document.getElementById('app'))
