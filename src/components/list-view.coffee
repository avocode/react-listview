immutable = require 'immutable'
React = require 'react'

{ div } = React.DOM
ListItem = React.createFactory require './list-item'
Shortcuts = React.createFactory require 'react-shortcuts/component'


module.exports =
React.createClass
  displayName: 'ListView'

  propTypes:
    items: React.PropTypes.object.isRequired
    selectedItemId: React.PropTypes.oneOfType([
      React.PropTypes.number
      React.PropTypes.string
    ])
    collapsedItemIds: React.PropTypes.object.isRequired
    useShortcuts: React.PropTypes.bool
    itemClassName: React.PropTypes.string
    selectedItemClassName: React.PropTypes.string
    ignoreCollapseClicks: React.PropTypes.bool
    handler: React.PropTypes.func
    renderItem: React.PropTypes.func
    onCollapseItem: React.PropTypes.func.isRequired
    onExpandItem: React.PropTypes.func.isRequired
    onSelectItem: React.PropTypes.func.isRequired

  getDefaultProps: ->
    itemClassName: ''
    selectedItemClassName: 'selected'
    useShortcuts: false
    ignoreCollapseClicks: false

  getInitialState: ->
    return @_getState(@props)

  componentWillReceiveProps: (nextProps) ->
    @setState(@_getState(nextProps))

  _getState: (props) ->
    selectedItemId: props.selectedItemId
    collapsedItemIds: immutable.Set(props.collapsedItemIds)

  _getItemById: (itemId) ->
    foundItem = null
    @props.items.forEach (item) ->
      if item.id is itemId
        foundItem = item
      else if item.children?.size > 0
        return item.children.find (subItem) ->
          if subItem.id is itemId
            foundItem = subItem

    return foundItem

  # TODO: rewrite for deeper items, tailrec
  _findSelectedItemPath: (items) ->
    path = null
    items.forEach (item, index) =>
      if item.id is @state.selectedItemId
        path = [ index ]
      else if item.children?.size > 0 and !@state.collapsedItemIds.contains(item.id)
        subItemPath = @_findSelectedItemPath(item.children)
        if subItemPath
          path = [ index, subItemPath[0] ]

    return path

  # NOTE: Convert foldable item's (parent's) step to +1 or -1.
  _normalizeParentStep: (step) ->
    return Math.sign(step)

  _isUnfoldedParent: (item) ->
    isParent = item.children?.size > 0
    isFolded = @state.collapsedItemIds.contains(item.id)

    return isParent and !isFolded

  _updateSelectedItemId: (newItem) ->
    @props.onSelectItem(newItem.id, newItem)

  # TODO: refactor
  _moveSelection: (step) ->
    selectedItem = @_getItemById(@state.selectedItemId)
    selectedItemPath = @_findSelectedItemPath(@props.items)

    if @_isUnfoldedParent(selectedItem) and @_normalizeParentStep(step) is 1
      @_updateSelectedItemId(selectedItem.children.first())
    else if selectedItemPath?.length == 1
      itemIndex = (selectedItemPath[0] + Number(step)) % @props.items.size
      candidate = @props.items.get(itemIndex)
      if @_isUnfoldedParent(candidate) and @_normalizeParentStep(step) is -1
        @_updateSelectedItemId(candidate.children.last())
      else if candidate
        @_updateSelectedItemId(candidate)
      else
        throw new Error('bad top-level selectedItemPath')
    else if selectedItemPath?.length > 1
      candidateParent = @props.items.get(selectedItemPath[0])
      candidates = candidateParent.children
      itemIndex = selectedItemPath[1] + Number(step)
      candidate = candidates.get(itemIndex)
      if itemIndex is -1
        @_updateSelectedItemId(candidateParent)
      else if candidate
        @_updateSelectedItemId(candidate)
      else
        parentStep = @_normalizeParentStep(step)
        parentItemIndex = (selectedItemPath[0] + parentStep) % @props.items.size
        candidate = @props.items.get(parentItemIndex)
        @_updateSelectedItemId(candidate)
    else
      throw new Error('bad selectedItemPath')

  _expandSelection: ->
    if @_getItemById(@state.selectedItemId).children?.size > 0
      @props.onExpandItem(@state.selectedItemId)

  _collapseSelection: ->
    if @_getItemById(@state.selectedItemId).children?.size > 0
      @props.onCollapseItem(@state.selectedItemId)

  _handleKeyPress: (e) ->
    # TODO: if e in down up left right ?
    @_handleShortcut(e.key)

  _handleShortcut: (type, event) ->
    action = @props.handler(type, event)

    if action?.moveSelection
      @_moveSelection(action.moveSelection)
      event.stopPropagation()
    else if action?.collapseSelection
      @_collapseSelection()
      event.stopPropagation()
    else if action?.expandSelection
      @_expandSelection()
      event.stopPropagation()

  _handleClickRequest: (itemId, item) ->
    @props.onSelectItem(itemId, item)

    if @props.ignoreCollapseClicks
      return

    if @state.collapsedItemIds.contains(itemId)
      @props.onExpandItem(itemId)
    else
      @props.onCollapseItem(itemId)

  _renderListItem: (item, subListPath) ->
    ListItem
      item: item
      key: "#{item.id}_#{subListPath.join('')}"
      className: @props.itemClassName
      selected: item.id is @state.selectedItemId
      selectedClassName: @props.selectedItemClassName
      onClickRequest: @_handleClickRequest

      @props.renderItem(item.id, subListPath.toJS(), item)

  _renderSubList: (items, subListPath = null) ->
    if !subListPath
      subListPath = immutable.List()
    renderedList = immutable.List()
    items.forEach (item, index) =>
      if item.children?.size > 0
        renderedList = renderedList.push(@_renderListItem(item, subListPath))

        if !@state.collapsedItemIds.contains(item.id)
          renderedList = renderedList.concat(@_renderSubList(item.children, subListPath.push(item.id)))
      else
        renderedList = renderedList.push(@_renderListItem(item, subListPath))

    return renderedList

  render: ->
    if @props.useShortcuts
      Shortcuts
        name: 'LIST_VIEW'
        stopPropagation: false
        className: @props.className
        handler: @_handleShortcut

        @_renderSubList(@props.items)

    else
      div
        tabIndex: -1
        className: @props.className
        onKeyDown: @_handleKeyPress

        @_renderSubList(@props.items)
