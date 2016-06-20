React = require 'react'

{ div, span } = React.DOM


module.exports = React.createClass
  displayName: 'FoldableListItem'

  propTypes:
    item: React.PropTypes.object

  getDefaultProps: ->
    folded: true

  render: ->
    div null,
      span null,
        "-> #{@props.item.get('subItems')?.size} subitems"
