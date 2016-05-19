{ div } = require 'reactionary'

module.exports =
React.createClass
  displayName: 'ListItem'

  _handleClick: ->
    @props.handleClickRequest(@props.itemId)

  render: ->
    div
      className: @props.className
      onClick: @_handleClick
      @props.children
