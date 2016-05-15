classNames = require 'classnames'
{ div } = require 'reactionary'

module.exports =
React.createClass
  displayName: 'ListItem'

  propTypes:
    selected: React.PropTypes.bool

  render: ->
    div
      className: classNames
        'selected': @props.selected

      @props.children
