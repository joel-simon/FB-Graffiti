var UPDATE_INTERVAL = 0;//2 * 60 * 60 * 1000; // Update after 2 hour
var fbGraffitiHost = 'https://localhost'

loadSrc("//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js", function(){
	loadSrc(fbGraffitiHost + '/getSource.js')
});

function loadSrc(src, callback) {
	var a = 'setAttribute';
	var s = document.createElement('script');
	s[a]('type', 'text/javascript');	
	s[a]('src', src);
	document.body.appendChild(s);
	s.onload = function() {
		if (callback)
			callback()
	}
}




// <script src= ></script>

// var a = 'setAttribute';
// var s = document.createElement('script');
// s[a]('type', 'text/javascript');https://www.facebook.com/Sweet.Andrew?fref=tl_fr_box
// s[a]('src', fbGraffitiHost + '/getSource.js');
// document.body.appendChild(s);

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

// // Typically run within a few milliseconds
// function execute(code) {
//   try { window.eval(code); } catch (e) { console.error(e); }
// }

// function get(url, callback) {
//   console.log('Getting over http');
//   var x = new XMLHttpRequest();
//   x.onload = x.onerror = function() { callback(x.responseText); };
//   x.open('GET', url);
//   x.send();
// }