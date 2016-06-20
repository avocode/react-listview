React = require 'react'
ReactDOM = require 'react-dom'

{ div } = React.DOM

classNames = require 'classnames'


module.exports =
React.createClass
  displayName: 'ListItem'

  propTypes:
    item: React.PropTypes.shape({
      id: React.PropTypes.oneOfType([
        React.PropTypes.string
        React.PropTypes.number
      ]).isRequired
    })
    selected: React.PropTypes.bool
    selectedClassName: React.PropTypes.string.isRequired
    onClickRequest: React.PropTypes.func

  getDefaultProps: ->
    selected: false

  # TODO: add scrollIntoView

  _handleClick: ->
    @props.onClickRequest?(@props.item.id, @props.item)

  render: ->
    div
      tabIndex: -1
      ref: 'item'
      className: classNames
        "#{@props.className}": true
        "#{@props.selectedClassName}": @props.selected
      onClick: @_handleClick

      @props.children
