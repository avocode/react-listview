{ div, span } = require 'reactionary'

module.exports = React.createClass
  displayName: 'SimpleListSubItem'

  propTypes:
    item: React.PropTypes.object

  render: ->
    div null,
      span 'subitem: '
      span "#{@props.item.get('id')}: "
      span @props.item.get('text')
