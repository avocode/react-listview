classNames = require 'classnames'
ReactDOM = require 'react-dom'

{ div } = require 'reactionary'

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

  componentDidMount: ->
    @_focusSelected(@props)

  componentWillReceiveProps: (nextProps) ->
    @_focusSelected(nextProps)

  _focusSelected: (props) ->
    if props.selected
      @refs['item'].focus()
      ReactDOM.findDOMNode(this).scrollIntoViewIfNeeded(true)

  _handleClick: ->
    @props.onClickRequest(@props.itemId)

  render: ->
    div
      tabIndex: 1
      ref: 'item'
      className: classNames
        "#{@props.className}": true
        "#{@props.selectedClassName}": @props.selected
      onClick: @_handleClick

      @props.children
