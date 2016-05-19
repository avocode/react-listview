classNames = require 'classnames'

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
    selectedClass: React.PropTypes.string.isRequired

  getDefaultProps: ->
    selected: false

  componentDidMount: ->
    @_focusSelected(@props)

  componentWillReceiveProps: (nextProps) ->
    @_focusSelected(nextProps)

  _focusSelected: (props) ->
    if props.selected
      @refs['item'].focus()

  _handleClick: ->
    @props.onClickRequest(@props.itemId)


  render: ->
    div
      tabIndex: 1
      ref: 'item'
      className: classNames
        "#{@props.selectedClass}": @props.selected
      onClick: @_handleClick

      @props.children
