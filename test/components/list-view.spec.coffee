assign = require 'lodash.assign'
chai = require 'chai'
enzyme = require 'enzyme'
Adapter = require 'enzyme-adapter-react-16'
immutable = require 'immutable'
React = require 'react'
sinon = require 'sinon'

ListView = require '../../src/components/list-view'
ListItem = require '../../src/components/list-item'

enzyme.configure({ adapter: new Adapter() });

expect = chai.expect


describe 'ListView', ->

  baseProps =
    items: immutable.List.of(
      { id: 1, text: '1' }
      { id: 2, text: '2' }
    )
    selectedItemId: 1
    collapsedItemIds: immutable.List()
    onCollapseItem: ->
    onExpandItem: ->
    onSelectItem: ->
    renderItem: ->

  it 'should render', ->
    listView = React.createElement(ListView, baseProps)
    wrapper = enzyme.shallow(listView)

    expect(wrapper.find(ListItem)).to.have.length(2)

  # TODO: add more tests
