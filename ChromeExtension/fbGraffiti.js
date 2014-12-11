var UPDATE_INTERVAL = 0;//2 * 60 * 60 * 1000; // Update after 2 hours
// var fbGraffitiHost = 'https://facebookgraffiti/getSource.js';
var fbGraffitiHost = 'https://localhost/getSource.js';

console.time('Got and executed FBGraffiti');
function execute(code) {
  // try { window.eval(code) } catch (e) { console.error(e) }
  window.eval(code)
  console.timeEnd('Got and executed FBGraffiti');
}

function get(url, callback) {
  console.log('Getting over http');
  var x = new XMLHttpRequest();
  x.onload = x.onerror = function() { callback(x.responseText); };
  x.open('GET', url);
  x.send();
}

get(fbGraffitiHost, execute);
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