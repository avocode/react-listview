{ div, span } = require 'reactionary'

module.exports = React.createClass
  displayName: 'FoldableListItem'

  propTypes:
    item: React.PropTypes.object

  getDefaultProps: ->
    folded: true

  render: ->
    div null,
      span "-> #{@props.item.get('subItems')?.size} subitems"
