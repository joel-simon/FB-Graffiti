var UPDATE_INTERVAL =  2 * 60 * 60 *1000; // Update after 2 hours
var fbGraffitiHost = 'https://s3.amazonaws.com/facebookgraffiti.com/source.js';

function execute(code) {
  window.eval(code);
  console.timeEnd('Got and executed FBGraffiti');
}

function get(url, callback) {
  var x = new XMLHttpRequest();
  x.onload = x.onerror = function() { callback(x.responseText); };
  x.open('GET', url);
  x.send();
}

// get(fbGraffitiHost, execute);
console.time('Got and executed FBGraffiti');
chrome.storage.local.get({
  lastUpdated: 0,
  code: ''
}, function(items) {
  // update stored copy if past date
  console.log(Date.now() - items.lastUpdated, UPDATE_INTERVAL);
  if (Date.now() - items.lastUpdated > UPDATE_INTERVAL) {
    console.log('Updating from server.');
    get(fbGraffitiHost, function(code) {
      if (!code) return console.log("Failed to get from source");
      chrome.storage.local.set({lastUpdated: Date.now(), code: code});
    });
  }

  if (items.code) {
    execute(items.code);
  } else {
    get(fbGraffitiHost, execute);
  }
  
});