React = require 'react'
ReactDOM = require 'react-dom-factories'
createClass = require 'create-react-class'
PropTypes = require 'prop-types';

{ div, span } = ReactDOM


module.exports = createClass
  displayName: 'SimpleListItem'

  propTypes:
    item: PropTypes.object.isRequired

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
