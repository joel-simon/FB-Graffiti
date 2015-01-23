var fbGraffitiHost = 'https://s3.amazonaws.com/fbgsource/';
var source = fbGraffitiHost + 'sourceDev.js'
console.time('Executed FBGraffiti');

window.updateFBG = function() {
  get(source, function(code) {
    if (!code) return console.log("Failed to get from source");
    chrome.storage.local.set({ lastUpdated: Date.now(), code: code });
  });
}

function execute(code) {
  eval('window.fbg = { host = "https://localhost/" };')
  eval(code);
  console.timeEnd('Executed FBGraffiti');
}

function get(url, callback) {
  console.log('Fetching fresh code.');
  var x = new XMLHttpRequest();
  x.onload = function() { callback(x.responseText); };
  x.onerror = function() { callback(null); };
  x.open('GET', url);
  x.send();
}


get(source, execute);
