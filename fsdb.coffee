# Reads from and saves to a YAML document on disk
# The data is always accessed from a "snapshot" of the YAML loaded into memory
# In dev mode, you can reload this snapshot on each request
# In produciton mode, data will be read straight from memory. hash-tag fast.

fs = require 'fs'
yaml = require 'js-yaml'
# FSObject = require './fsobject'

# Save to disk
save = (path, dict) ->
  text = yaml.safeDump dict
  fs.writeFile path, text, (error) ->
    console.log error

# Load from disk
load = (path) ->
  try
    db = yaml.safeLoad(fs.readFileSync(path, 'utf8'))
    console.log('loaded: ', db)
    return db
  catch error
    console.log error

# enclose objects in data-* tags
parseObj = (obj, listName) ->
  for prop, text of obj
    if prop != 'id'
      obj[prop] = tapMarkup(text, prop, listName, obj.id)
  # console.log "parsed object: " + obj
  return obj

# give a text enough data-* for editing
tapMarkup = (text, propName, listName, id) ->
  "<span
  style='display:inline-block'
  #{dataAttr('prop', propName)}
  #{dataAttr('list', listName)}
  #{dataAttr('id', id)}
  >#{text}</span>"
  # "#{listName}: #{propName}: #{text}"

dataAttr = (name, text) ->
  if text
    "data-design-#{name}=#{text}"
  else
    ""

class FSDB
  constructor: (@path) ->
    @reload(@path)

  reload: () ->
    @snapshot = load(@path) or {}

  # Return an array of author objects
  # if empty, make a new object
  list: (listName) ->
    # Get list or create list
    # list = @snapshot[listName] or (@snapshot[listName] = [])
    # Give list objects helper functions or add a new object
    # list = (new FSObject(obj) for obj in list) or [new FSObject]
    list = (parseObj(obj, listName) for obj in @snapshot[listName])

  # Create a tap-to-author area
  author: (listName, propName, constraints) ->
    list = @snapshot[listName] or (@snapshot[listName] = [])
    text = list[propName] or (list[propName] = 'new')
    console.log @snapshot
    "<span
      style='display:inline-block'
      data-author-list='#{listName}'
      data-author-prop='#{propName}'>#{text}</span>"    


  # Read-only
  display: () ->

  # Edit the database
  draft: (pair) ->
    key = pair[0]
    value = pair[1]
    # if @snapshot[key]? # Check if dict exists.
    @snapshot[key] = value 
    save(@path, @snapshot)

  singleLine: (dataName) ->
    text = @snapshot[dataName] or (@snapshot[dataName] = 'new editable')
    "<span
      style='display:inline-block'
      data-single-line='#{dataName}'>#{text}</span>"

  readOnly: (dataName) ->
    text = @snapshot[dataName] or (@snapshot[dataName] = 'new editable')
    "#{text}"

module.exports = FSDB