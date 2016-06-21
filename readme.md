# React ListView

**Create List components with keyboard support**

![Build Status](https://travis-ci.org/avocode/react-listview.svg?branch=master)

## Usage

```
npm i react-listview-keys --save
```

## Example

![React ListView example](https://s3.amazonaws.com/f.cl.ly/items/322J3v0u1n2l39153327/example.gif?v=fe99b357)

```
ListView = require 'react-listview'

ListView
  className: 'list-view'
  itemClassName: 'list-view__item'
  selectedItemClassName: 'list-view__item--selected'
  items: @state.listItems
  selectedItemId: @state.selectedListItemId
  collapsedItemIds: @state.collapsedListItemIds
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
```


### Props

- `className` - CSS class of the whole ListView component
- `itemClassName` - CSS class of non-selected ListItem
- `selectedItemClassName` - CSS class of selected ListItem

- `items` - immutable.List of items to render

- `selectedItemId` - `id` of selected items
- `collapsedItemIds` - immutable.List of `id`s of collapsed parent items

- `onCollapseItem` - callback called when collapsing a parent item
- `onExpandItem` - callback called when expanding a parent item
- `onSelectItem` - callback called after click on an item
- `renderItem` - function that renders the item (passed as callback so  apps can handle the rendering of the main content itself)


## Development

```
git clone git@github.com:avocode/react-listview.git
cd react-listview

npm install
```


Run tests:
```
npm test
```

### TODOs
- refactor logic - support deeper lists
- add shouldcomponentupdates
- improve tests
- rethink tabIndices
- add more examples
- add prop for last item skipping
