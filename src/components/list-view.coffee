immutable = require 'immutable'
Shortcuts = React.createFactory require 'react-shortcuts/component'

{ div } = require 'reactionary'

ListItem = React.createFactory require './list-item'

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
    handler: React.PropTypes.func
    useShortcuts: React.PropTypes.bool
    renderItem: React.PropTypes.func
    selectedItemClass: React.PropTypes.string
    onCollapseItem: React.PropTypes.func
    onSelectedItemIdChange: React.PropTypes.func
    # TODO: add default collapsing prop

  getDefaultProps: ->
    selectedItemClass: 'selected'
    useShortcuts: false


  getInitialState: ->
    selectedItemId: @props.selectedItemId
    collapsedItemIds: immutable.Set(@props.collapsedItemIds)

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

  # convert foldable item's (parent's) step to +1 or -1
  _normalizeParentStep: (step) ->
    return Math.sign(step)

  _isUnfoldedParent: (item) ->
    isParent = item.children?.size > 0
    isFolded = @state.collapsedItemIds.contains(item.id)

    return isParent and !isFolded

  _updateSelectedItemId: (newItemId) ->
    @setState selectedItemId: newItemId
    @props.onSelectedItemIdChange?(newItemId)

  # TODO: refactor
  _moveSelection: (step) ->
    selectedItem = @_getItemById(@state.selectedItemId)
    selectedItemPath = @_findSelectedItemPath(@props.items)

    if @_isUnfoldedParent(selectedItem) and @_normalizeParentStep(step) is 1
      @_updateSelectedItemId(selectedItem.children.first().id)
    else if selectedItemPath?.length == 1
      itemIndex = (selectedItemPath[0] + Number(step)) % @props.items.size
      candidate = @props.items.get(itemIndex)
      if @_isUnfoldedParent(candidate) and @_normalizeParentStep(step) is -1
        @_updateSelectedItemId(candidate.children.last().id)
      else if candidate
        @_updateSelectedItemId(candidate.id)
      else
        throw new Error('bad top-level selectedItemPath')
    else if selectedItemPath?.length > 1
      candidateParent = @props.items.get(selectedItemPath[0])
      candidates = candidateParent.children
      itemIndex = selectedItemPath[1] + Number(step)
      candidate = candidates.get(itemIndex)
      if itemIndex is -1
        @_updateSelectedItemId(candidateParent.id)
      else if candidate
        @_updateSelectedItemId(candidate.id)
      else
        parentStep = @_normalizeParentStep(step)
        parentItemIndex = (selectedItemPath[0] + parentStep) % @props.items.size
        candidate = @props.items.get(parentItemIndex)
        @_updateSelectedItemId(candidate.id)
    else
      throw new Error('bad selectedItemPath')

  _collapseSelection: ->
    if @_getItemById(@state.selectedItemId).children?.size > 0
      collapsedItemIds =
        @state.collapsedItemIds.add(@state.selectedItemId)

      @setState({ collapsedItemIds })
      @props.onCollapseItem?(collapsedItemIds)

  _expandSelection: ->
    if @_getItemById(@state.selectedItemId).children?.size > 0
      collapsedItemIds =
        @state.collapsedItemIds.delete(@state.selectedItemId)

      @setState({ collapsedItemIds })
      @props.onCollapseItem?(collapsedItemIds)

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

  _handleClickRequest: (itemId) ->
    if @state.collapsedItemIds.contains(itemId)
      nextCollapsedItemIds = @state.collapsedItemIds.remove(itemId)
    else
      nextCollapsedItemIds = @state.collapsedItemIds.add(itemId)

    @setState
      selectedItemId: itemId
      collapsedItemIds: nextCollapsedItemIds

  _renderListItem: (item, subListPath) ->
    ListItem
      itemId: item.id
      key: "#{item.id}_#{subListPath.join('')}"
      selected: item.id is @state.selectedItemId
      selectedClass: @props.selectedItemClass
      onClickRequest: @_handleClickRequest

      @props.renderItem(item.id, subListPath.toJS())

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
        handler: @_handleShortcut

        @_renderSubList(@props.items)

    else
      div
        tabIndex: -1
        onKeyDown: @_handleKeyPress

        @_renderSubList(@props.items)
