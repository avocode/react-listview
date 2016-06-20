React = require 'react'

{ div, span } = React.DOM


module.exports = React.createClass
  displayName: 'SimpleListItem'

  propTypes:
    item: React.PropTypes.object.isRequired

  render: ->
    div null,
      if @props.item.get('shifter')
        span null,
          "#{@props.item.get('shifter')} "
      else
        span null,
          "#{@props.item.get('id')}: "

      span null,
        @props.item.get('text')
