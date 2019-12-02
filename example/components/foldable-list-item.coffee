React = require 'react'
ReactDOM = require 'react-dom-factories'
createClass = require 'create-react-class'
PropTypes = require 'prop-types';

{ div, span } = ReactDOM


module.exports = createClass
  displayName: 'FoldableListItem'

  propTypes:
    item: PropTypes.object.isRequired
    folded: PropTypes.bool

  getDefaultProps: ->
    folded: true

  render: ->
    div null,
      span null,
        "-> #{@props.item.get('subItems')?.size} subitems"
