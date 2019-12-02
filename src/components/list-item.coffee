React = require 'react'
ReactDOM = require 'react-dom-factories'
PropTypes = require 'prop-types';
createClass = require 'create-react-class'

{ div } = ReactDOM

classNames = require 'classnames'


module.exports =
createClass
  displayName: 'ListItem'

  propTypes:
    item: PropTypes.shape({
      id: PropTypes.oneOfType([
        PropTypes.string
        PropTypes.number
      ]).isRequired
    })
    selected: PropTypes.bool
    selectedClassName: PropTypes.string.isRequired
    onClickRequest: PropTypes.func

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
