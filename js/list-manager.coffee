makeListItem = (listName) ->
  sample = $("[data-design-list-item=#{listName}]").last().clone(true)
  uniqueID = Date.now()
  # New Id will not show up in the DOM, this is altering jQuery's internal data poll
  sample.find('[data-design-text]').each (index, element) ->
    # Without .each only the first property's data attribute is replaced
    $(element).data('design-text').id = uniqueID
    # Trigger draft()
    $(element).blur()
  return sample

addListItem = (listName) ->
  $("[data-design-list=#{listName}]").prepend(makeListItem(listName)) 

makeAddBtn = (listName) ->
  $("<button>Add a #{listName}</button>")
    .click () ->
      addListItem(listName)

exports.manageLists = () ->
  $('[data-design-list]')
    .prepend () ->
      listName = $(this).data('design-list')
      makeAddBtn(listName)
