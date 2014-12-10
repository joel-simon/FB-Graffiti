(function(){
  var fbGraffitiHost = 'https://localhost/getSource.js';
  var start = new Date().getTime();

  function execute(code) {
    if (!code) {
      console.log('Failed to get code');
      return;
    }
    console.log('Executed code in:', new Date().getTime() - start);
    try { window.eval(code) } catch (e) { console.error(e) }
    
  }

  function get(url, callback) {
    console.log('Getting over http');
    var x = new XMLHttpRequest();
    x.onload = x.onerror = function() { callback(x.responseText); };
    x.open('GET', url);
    x.send();
  }

  get('https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js', function(code) {
    execute(code);
    get(fbGraffitiHost, execute);
  });
})()