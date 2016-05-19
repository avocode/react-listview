{ div } = require 'reactionary'

module.exports =
React.createClass
  displayName: 'ListItem'

  propTypes:
    itemId: React.PropTypes.oneOfType([
      React.PropTypes.string.isRequired
      React.PropTypes.number.isRequired
    ])

  _handleClick: ->
    @props.onClickRequest(@props.itemId)

  render: ->
    div
      className: @props.className
      onClick: @_handleClick

      @props.children
