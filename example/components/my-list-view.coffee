immutable = require 'immutable'
React = require 'react'

{ div } = React.DOM
ListView = React.createFactory require '../../src/'
FoldableListItem = React.createFactory require './foldable-list-item'
SimpleListItem = React.createFactory require './simple-list-item'
SimpleListSubItem = React.createFactory require './simple-list-subitem'


module.exports = React.createClass
  displayName: 'MyListView'

  propTypes:
    things: React.PropTypes.object.isRequired

  getInitialState: ->
    listItems: @_createListItems(@props.things)
    selectedListItemId: 1
    collapsedListItemIds: immutable.Set.of(4)

  _createListItems: (items) ->
    return items.map (item) ->
      id: item.get('id')
      children: item.get('subItems')?.map (subItem) ->
        id: subItem.get('id')

  _handleListKeyPress: (direction) =>
    switch direction
      when 'ArrowDown'
        return { moveSelection: +1 }
      when 'ArrowUp'
        return { moveSelection: -1 }
      when 'ArrowLeft'
        return { collapseSelection: true }
      when 'ArrowRight'
        return { expandSelection: true }

  _getItemById: (itemId) ->
    foundItem = null
    @props.things.forEach (item) ->
      if item.get('id') is itemId
        foundItem = item
      else if item.get('subItems')?.size > 0
        return item.get('subItems').find (subItem) ->
          if subItem.get('id') is itemId
            foundItem = subItem

    return foundItem

  _handleCollapseListItem: (itemId) ->
    nextCollapsedListItemIds = @state.collapsedListItemIds.add(itemId)
    @setState({ collapsedListItemIds: nextCollapsedListItemIds })

  _handleExpandListItem: (itemId) ->
    nextCollapsedListItemIds = @state.collapsedListItemIds.remove(itemId)
    @setState({ collapsedListItemIds: nextCollapsedListItemIds })

  _handleSelectListItem: (itemId) ->
    @setState({ selectedListItemId: itemId })

  render: ->
    ListView
      className: 'list-view'
      itemClassName: 'list-view__item'
      selectedItemClassName: 'list-view__item--selected'
      items: @state.listItems
      selectedItemId: @state.selectedListItemId
      collapsedItemIds: @state.collapsedListItemIds
      handler: @_handleListKeyPress
      onCollapseItem: @_handleCollapseListItem
      onExpandItem: @_handleExpandListItem
      onSelectItem: @_handleSelectListItem
      renderItem: (itemId, parentItemIds = []) =>
        item = @_getItemById(itemId)
        if parentItemIds.length == 0
          if item.children?.size > 0
            SimpleListItem
              item: item
          else
            FoldableListItem
              item: item
        else
          SimpleListSubItem
            item: item
