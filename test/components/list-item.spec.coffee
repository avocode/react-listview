assign = require 'lodash.assign'
chai = require 'chai'
enzyme = require 'enzyme'
Adapter = require 'enzyme-adapter-react-16'
immutable = require 'immutable'
React = require 'react'
sinon = require 'sinon'

ListItem = require '../../src/components/list-item'

enzyme.configure({ adapter: new Adapter() });

expect = chai.expect


describe 'ListItem', ->

  baseProps =
    item:
      id: 1
      text: '1'
    selected: false
    selectedClassName: 'selelected'
    onClickRequest: ->

  it 'should render', ->
    listItem = React.createElement(ListItem, baseProps)
    wrapper = enzyme.shallow(listItem)

    expect(wrapper.find('div')).to.have.length(1)

  it 'should render as selected', ->
    selectedProps = assign {}, baseProps,
      selected: true

    listItem = React.createElement(ListItem, selectedProps)
    wrapper = enzyme.shallow(listItem)

    expect(wrapper.find('.selelected')).to.have.length(1)

  it 'should be able to handle click', ->
    props = assign {}, baseProps,
      onClickRequest: sinon.spy()

    listItem = React.createElement(ListItem, props)
    wrapper = enzyme.shallow(listItem)

    wrapper.find('div').simulate('click')
    expect(props.onClickRequest.called).to.be.ok
