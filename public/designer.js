(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var revert, save;

revert = function(el) {
  document.execCommand('undo');
  return el.blur();
};

save = function(event, el, socket) {
  var key, value;
  key = $(el).data('single-line');
  console.log('html: ' + $(el).html());
  value = $(el).text();
  console.log('drafting ' + value);
  socket.emit('draft', [key, value]);
  el.blur();
  return event.preventDefault();
};

exports.editable = function(socket) {
  return $('[data-single-line]').attr('contenteditable', true).keydown(function(event) {
    switch (event.which) {
      case 27:
        return revert(this);
      case 13:
        return save(event, this, socket);
    }
  }).blur(function(event) {
    return save(event, this, socket);
  });
};


},{}]},{},[1])