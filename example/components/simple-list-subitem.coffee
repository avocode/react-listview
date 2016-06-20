React = require 'react'

{ div, span } = React.DOM


module.exports = React.createClass
  displayName: 'SimpleListSubItem'

  propTypes:
    item: React.PropTypes.object

  render: ->
    div null,
      span null,
        'subitem: '

      span null,
        "#{@props.item.get('id')}: "

      span null,
        @props.item.get('text')
