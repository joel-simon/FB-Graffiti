var UPDATE_INTERVAL =  2 * 60 * 60 *1000; // Update after 2 hours
var fbGraffitiHost = 'https://s3.amazonaws.com/facebookgraffiti.com/source.js';

window.updateFBG = function() {
  get(fbGraffitiHost, function(code) {
    if (!code) return console.log("Failed to get from source");
    console.log('Got fresh code.');
    chrome.storage.local.set({ lastUpdated: Date.now(), code: code });
  });
}

function execute(code) {
  // var script = document.createElement("script");
  // script.innerHTML = code;
  // document.body.appendChild(script);
  eval(code);
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
  if (Date.now() - items.lastUpdated > UPDATE_INTERVAL) {
    console.log('Updating from server.');
    window.updateFBG();
  }
  if (items.code) {
    execute(items.code);
  } else {
    get(fbGraffitiHost, execute);
  }
  
});

