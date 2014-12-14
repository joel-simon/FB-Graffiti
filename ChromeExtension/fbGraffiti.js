var UPDATE_INTERVAL = 0;//2 * 60 * 60 * 1000; // Update after 2 hours
var fbGraffitiHost = 'https://fb-graffiti.com/getSource.js';

function execute(code) {
	console.log(code);
  // try { window.eval(code) } catch (e) { console.error(e) }
  window.eval(code)
  console.timeEnd('Got and executed FBGraffiti');
}

function get(url, callback) {
	console.time('Got and executed FBGraffiti');
  console.log('Getting over http');
  var x = new XMLHttpRequest();
  x.onload = x.onerror = function() { callback(x.responseText); };
  x.open('GET', url);
  x.send();
}

// get(fbGraffitiHost, execute);


// var s = document.createElement("script");
// s.type = "text/javascript";
// s.src = "http://54.174.220.141:8080/getSource.js";
// document.body.appendChild(s);


// chrome.storage.local.get({
//   lastUpdated: 0,
//   code: ''
// }, function(items) {
//   // console.log(Date.now() - items.lastUpdated > UPDATE_INTERVAL);
//   if (Date.now() - items.lastUpdated > UPDATE_INTERVAL) {
//       // Get updated file, and if found, save it.
//       get(fbGraffitiHost, function(code) {
//         if (!code) return;
//         chrome.storage.local.set({lastUpdated: Date.now(), code: code});
//       });
//   }
//   if (items.code) {
//     console.log('Got local copy:', new Date().getTime() - start);
//     execute(items.code);
//   } else {
//   //No cached version yet. Load from extension
//     get(fbGraffitiHost, execute); //chrome.extension.getURL('ga.js')
//   }
// });