classNames = require 'classnames'
React = require 'react'
ReactDOM = require 'react-dom'

{ div } = React.DOM

module.exports =
React.createClass
  displayName: 'ListItem'

  propTypes:
    itemId: React.PropTypes.oneOfType([
      React.PropTypes.string.isRequired
      React.PropTypes.number.isRequired
    ])
    selected: React.PropTypes.bool
    selectedClassName: React.PropTypes.string.isRequired

  getDefaultProps: ->
    selected: false

  # TODO: add scrollIntoView

  _handleClick: ->
    @props.onClickRequest(@props.itemId)

  render: ->
    div
      tabIndex: -1
      ref: 'item'
      className: classNames
        "#{@props.className}": true
        "#{@props.selectedClassName}": @props.selected
      onClick: @_handleClick

      @props.children
