makeListItem = (listName) ->
  sample = $("[data-design-list-item=#{listName}]").last().clone(true)
  uniqueID = Date.now()
  # New Id will not show up in the DOM, this is altering jQuery's internal data poll
  sample.find('[data-design-text]').each (index, element) ->
    # Without .each only the first property's data attribute is replaced
    $(element).data('design-text').id = uniqueID
    # obj = $(element).data('design-text')
    # for prop, text of obj
      # obj[prop] = 'sample' if prop != 'id'
    # $(element).data('design-text')[prop] = 'sample'
    # Trigger draft()
    # $(element).blur() # BUGGED: randomly cauesing <span> to be saved in db
  return sample

addListItem = (listName) ->
  $("[data-design-list-actions=#{listName}]").after(makeListItem(listName)) 

makeAddBtn = (listName) ->
  $("<button data-design-list-actions='#{listName}' data-design-add-button>+</button>")
    .click () ->
      addListItem(listName)

makeDeleteBtn = (listName, id, element, socket) ->
  $("<button data-design-delete-button>-</button>")
    .click () ->
      socket.emit('delete', {list: listName, id: id})
      $(element).remove()

exports.manageLists = (socket) ->
  $('[data-design-list]')
    .prepend () ->
      listName = $(this).data('design-list')
      makeAddBtn(listName)
  $('[data-design-list-item]')
    .prepend () ->
      obj = $(this).find('[data-design-text]').data('design-text')
      listName = obj.list
      id = obj.id
      # console.log "#{listName}, #{id}"
      makeDeleteBtn(listName, id, this, socket)