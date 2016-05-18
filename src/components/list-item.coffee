{ div } = require 'reactionary'

module.exports =
React.createClass
  displayName: 'ListItem'

  render: ->
    div className: @props.className,
      @props.children
