(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var PopUp, popup, socket;

socket = io.connect('/');

PopUp = require('./popup');

popup = new PopUp(socket);

$('[data-design-text]').on('click.preventDefault', function(event) {
  return event.preventDefault();
});

$('[data-design-text]').on('click.popup', function(event) {
  return popup.setTargetAndUnhide(this);
});


},{"./popup":2}],2:[function(require,module,exports){
var PopUp, editor;

editor = require('./single-line-editor');

PopUp = (function() {
  function PopUp(socket) {
    this.socket = socket;
    this.edit = $("<button data-design-action-edit>Edit</button>");
    this.popup = $("<div></div>").append(this.edit);
    this.popup.css({
      position: 'absolute',
      'z-index': 200
    });
    this.popup.appendTo('body');
  }

  PopUp.prototype.setTargetAndUnhide = function(target) {
    console.log('set target: ' + $(target).text());
    this.target = $(target);
    this.setEditTarget();
    return this.position();
  };

  PopUp.prototype.setEditTarget = function() {
    return this.edit.click((function(_this) {
      return function() {
        console.log("Clicked Edit Button");
        return _this.beginEdit();
      };
    })(this));
  };

  PopUp.prototype.position = function() {
    var left, top, _ref;
    _ref = this.target.offset(), top = _ref.top, left = _ref.left;
    top = top + this.target.height();
    return this.popup.css({
      top: top,
      left: left
    });
  };

  PopUp.prototype.beginEdit = function() {
    editor.editable(this.target, this.socket);
    return this.target.focus();
  };

  return PopUp;

})();

module.exports = PopUp;


},{"./single-line-editor":3}],3:[function(require,module,exports){
var draft, revert;

revert = function(el) {
  document.execCommand('undo');
  return el.blur();
};

draft = function(event, el, socket) {
  var attr;
  attr = $(el).data('design-text');
  attr.text = $(el).text();
  console.log('drafting ' + attr.text);
  return socket.emit('draft', attr);
};

exports.editable = function(element, socket) {
  console.log('making a editable');
  return $(element).attr('contenteditable', true).keydown(function(event) {
    switch (event.which) {
      case 27:
        return revert(this);
      case 13:
        event.preventDefault();
        return this.blur();
    }
  }).blur(function(event) {
    return draft(event, this, socket);
  });
};


},{}]},{},[1])