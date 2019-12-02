React = require 'react'
ReactDOM = require 'react-dom-factories'
createClass = require 'create-react-class'
PropTypes = require 'prop-types';

{ div, span } = ReactDOM


module.exports = createClass
  displayName: 'SimpleListSubItem'

  propTypes:
    item: PropTypes.object.isRequired

  render: ->
    div null,
      span null,
        'subitem: '

      span null,
        "#{@props.item.get('id')}: "

      span null,
        @props.item.get('text')
