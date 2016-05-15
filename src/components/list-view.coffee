immutable = require 'immutable'
createMousetrap = require 'mousetrap'

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
    processKeyPress: React.PropTypes.func
    renderItem: React.PropTypes.func
    # TODO: add default collapsing prop

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

  # TODO: refactor
  _moveSelection: (step) ->
    selectedItem = @_getItemById(@state.selectedItemId)
    selectedItemPath = @_findSelectedItemPath(@props.items)

    if @_isUnfoldedParent(selectedItem) and @_normalizeParentStep(step) is 1
      @setState selectedItemId: selectedItem.children.first().id
    else if selectedItemPath?.length == 1
      itemIndex = (selectedItemPath[0] + Number(step)) % @props.items.size
      candidate = @props.items.get(itemIndex)
      if @_isUnfoldedParent(candidate) and @_normalizeParentStep(step) is -1
        @setState selectedItemId: candidate.children.last().id
      else if candidate
        @setState selectedItemId: candidate.id
      else
        throw new Error('bad top-level selectedItemPath')
    else if selectedItemPath?.length > 1
      candidateParent = @props.items.get(selectedItemPath[0])
      candidates = candidateParent.children
      itemIndex = selectedItemPath[1] + Number(step)
      candidate = candidates.get(itemIndex)
      if itemIndex is -1
        @setState selectedItemId: candidateParent.id
      else if candidate
        @setState selectedItemId: candidate.id
      else
        parentStep = @_normalizeParentStep(step)
        candidate = @props.items.get(selectedItemPath[0] + parentStep)
        @setState selectedItemId: candidate.id
    else
      throw new Error('bad selectedItemPath')

  _collapseSelection: ->
    if @_getItemById(@state.selectedItemId).children?.size > 0
      collapsedItemIds =
        @state.collapsedItemIds.add(@state.selectedItemId)
      @setState({ collapsedItemIds })

  _expandSelection: ->
    if @_getItemById(@state.selectedItemId).children?.size > 0
      collapsedItemIds =
        @state.collapsedItemIds.delete(@state.selectedItemId)
      @setState({ collapsedItemIds })

  _handleKeyPress: (e) ->
    # if e in down up left right ?
    action = @props.processKeyPress(e.key)

    if action?.moveSelection
      @_moveSelection(action.moveSelection)
    else if action?.collapseSelection
      @_collapseSelection()
    else if action?.expandSelection
      @_expandSelection()

  _renderListItem: (item, subListPath) ->
    ListItem
      key: item.id
      selected: item.id is @state.selectedItemId

      @props.renderItem(item.id, subListPath)

  _renderSubList: (items, subListPath = []) ->
    renderedList = immutable.List()
    items.forEach (item, index) =>
      if item.children?.size > 0
        subListPath.push(item.id)
        renderedList = renderedList.push(@_renderListItem(item, subListPath))

        if !@state.collapsedItemIds.contains(item.id)
          renderedList = renderedList.concat(@_renderSubList(item.children))
      else
        renderedList = renderedList.push(@_renderListItem(item))

    return renderedList

  render: ->
      div
        tabIndex: 1
        onKeyDown: @_handleKeyPress
        # TODO: onClick: @_handleClick

        @_renderSubList(@props.items)
