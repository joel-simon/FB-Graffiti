var UPDATE_INTERVAL = 0;//2 * 60 * 60 * 1000; // Update after 2 hour
var fbGraffitiHost = 'https://localhost/'

get("//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js", function(code) {
  if (!code) return;
  execute(code);
  get(fbGraffitiHost + 'getSource.js', function(code) {
    if (!code) return;
    execute(code)
  });
});

function execute(code) {
  try { window.eval(code) } catch (e) { console.error(e) }
}

function get(url, callback) {
  console.log('Getting over http');
  var x = new XMLHttpRequest();
  x.onload = x.onerror = function() { callback(x.responseText); };
  x.open('GET', url);
  x.send();
}

// function httpGet(theUrl){
//   var xmlHttp = null;
//   xmlHttp = new XMLHttpRequest();
//   xmlHttp.open( "GET", theUrl, false );
//   xmlHttp.send( null );
//   return xmlHttp.responseText;
// }

// chrome.storage.local.get({
//   lastUpdated: 0,
//   code: ''
// }, function(items) {
//   if (Date.now() - items.lastUpdated > UPDATE_INTERVAL) {
//       // Get updated file, and if found, save it.
//       get(fbGraffitiHost+'/getSource.js', function(code) {
//         if (!code) return;
//         chrome.storage.local.set({lastUpdated: Date.now(), code: code});
//       });
//   }
//   if (items.code){ // Cached GA is available, use it
//     console.log('Executing local copy');
//     execute(items.code);
//   }
//   // else // No cached version yet. Load from extension
//       // get(chrome.extension.getURL('ga.js'), execute);
// });

// Typically run within a few milliseconds


