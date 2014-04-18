makeListItem = (listName) ->
  sample = $("[data-design-list-item=#{listName}]").last().clone()
  uniqueID = Date.now()
  # New Id will not show up in the DOM, this is altering jQuery's internal data poll
  sample.find('[data-design-text]').data('design-text').id = uniqueID
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
