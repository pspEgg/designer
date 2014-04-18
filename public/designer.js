(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var list, single, socket;

socket = io.connect('/');

single = require('./single-line-editor');

list = require('./list-manager');

single.editable(socket);

list.manageLists(socket);


},{"./list-manager":2,"./single-line-editor":3}],2:[function(require,module,exports){
var addListItem, makeAddBtn, makeDeleteBtn, makeListItem;

makeListItem = function(listName) {
  var sample, uniqueID;
  sample = $("[data-design-list-item=" + listName + "]").last().clone(true);
  uniqueID = Date.now();
  sample.find('[data-design-text]').each(function(index, element) {
    $(element).data('design-text').id = uniqueID;
    return $(element).blur();
  });
  return sample;
};

addListItem = function(listName) {
  return $("[data-design-list-actions=" + listName + "]").after(makeListItem(listName));
};

makeAddBtn = function(listName) {
  return $("<button data-design-list-actions='" + listName + "'>Add a " + listName + "</button>").click(function() {
    return addListItem(listName);
  });
};

makeDeleteBtn = function(listName, id, element, socket) {
  return $("<button>Delete</button>").click(function() {
    socket.emit('delete', {
      list: listName,
      id: id
    });
    return $(element).remove();
  });
};

exports.manageLists = function(socket) {
  $('[data-design-list]').prepend(function() {
    var listName;
    listName = $(this).data('design-list');
    return makeAddBtn(listName);
  });
  return $('[data-design-list-item]').prepend(function() {
    var id, listName, obj;
    obj = $(this).find('[data-design-text]').data('design-text');
    listName = obj.list;
    id = obj.id;
    return makeDeleteBtn(listName, id, this, socket);
  });
};


},{}],3:[function(require,module,exports){
var draft, revert;

revert = function(el) {
  document.execCommand('undo');
  return el.blur();
};

draft = function(event, el, socket) {
  var attr;
  attr = $(el).data('design-text');
  console.log('html: ' + $(el).html());
  attr.text = $(el).text();
  console.log('drafting ' + attr.text);
  socket.emit('draft', attr);
  el.blur();
  return event.preventDefault();
};

exports.editable = function(socket) {
  return $('[data-design-text]').attr('contenteditable', true).keydown(function(event) {
    switch (event.which) {
      case 27:
        return revert(this);
      case 13:
        this.blur();
        return event.preventDefault();
    }
  }).blur(function(event) {
    return draft(event, this, socket);
  });
};


},{}]},{},[1])