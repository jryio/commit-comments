// JavaScript taken from https://github.com/thebearjew/thebearjew.github.io
// This code was used open links, directing outside of jry.io, to open in a new browser tab.

// Adds attribute "target=_blank" to links to all external sites
function handleExternalLinks () {
  var host = location.host
  var allLinks = document.querySelectorAll('a')
  forEach(allLinks, function (elem, index) {
    checkExternalLink(elem, host)
  })
}

function checkExternalLink (item, hostname) {
  var href = item.href
  var itemHost = href.replace(/https?:\/\/([^\/]+)(.*)/, '$1')
  if (itemHost !== '' && itemHost !== hostname) {
    // console.log('Changing ' + item + ' to target=_blank')
    item.target = '_blank'
  }
}

// NodeList forEach function
// @commit: Added forEach function for NodeList elements
/* @commit added Minos's name to the funciton */
function forEach (array, callback, scope) {
  for (var i = 0; i < array.length; ++i) {
    callback.call(scope, array[i], i)
  }
}

