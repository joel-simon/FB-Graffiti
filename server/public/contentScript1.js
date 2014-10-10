// var domain = 'http://fb-graffiti.com/';

(function(){
  console.log('HERE I AM ');
  // var domain = 'http://ec2-54-86-103-35.compute-1.amazonaws.com:3000/'
  var domain = 'http://localhost:3000/'
  var isDrawing = false;
  var changesMade = false;
  var mainImageCanvas = null;
  var breakCache = {};
  var posts = {};
  var currentCanvas;
  var prevX = 0;
  var currX = 0;
  var prevY = 0;
  var currY = 0;
  var sendInterval;

  var profilePostsSelector = ".timelineUnitContainer";
  var timelinePostsSelector = "[id*="+"topnews_main"+"] > * > * > * > * ";
  var groupPostsSelector = ".userContentWrapper";

  var flag;
  var dot_flag;
  var first = false;
  var prev_pathname = '';
  var prev_search = '';
  var shareBtn;

  var onDomSettled = (function() {
    var timer = null;
    return function(t, cb) {
      if (timer != null) {
        clearTimeout(timer);
      }
      timer = setTimeout(function() {
        timer = null;
        return cb();
      }, t);
    }
  })();


  main();
    
  function main() {
    onNewPage();
    setInterval(onNewPage, 300);
    $('#pagelet_bluebar > * > *')[0].style.position = "fixed";
    var sprayIcon = document.createElement('img');
    sprayIcon.id = 'sprayImage';
    sprayIcon.src = chrome.extension.getURL("images/sprayCan.png");
    sprayIcon.style.width = "35px";
    sprayIcon.style.height = "35px";
    sprayIcon.style.top = "2px";
    sprayIcon.style.left = "-28px";
    sprayIcon.style.float = "left";
    sprayIcon.style.cursor= "pointer";
    $(sprayIcon).css("z-index", 2000);
    sprayIcon.style.position = "absolute";
    sprayIcon.style.opacity = (isDrawing) ? "1.0" : "0.5";
    $('#pageLogo')[0].appendChild(sprayIcon);
    if (window.location.pathname == '/') {
      $(sprayIcon).hide();
    }



    $(sprayIcon).click(function(e) {
      e.stopPropagation();
      if (isDrawing) {
        isDrawing = false;
        sprayIcon.style.opacity = "0.5";
        $('.myCanvas').hide();
        $('.canvasImage').hide();
        $('#shareButton').hide();
        $('.colorPicker,.radiusSelector').animate({left: "-=50",}, 500, function(){});
        $('a.snowliftPager').show();
      } else {
        if (window.location.pathname == '/') {
          alert('Graffiti on timeline is currently not available.');
        } else {
          isDrawing = true;
          sprayIcon.style.opacity = "1.0";
          $('.myCanvas').show();
          $('.canvasImage').show();
          $('#shareButton').show();
          $('.colorPicker,.radiusSelector').animate({left: "+=50",}, 500, function(){});
          $('a.snowliftPager').hide();
        }
      }
    });
    document.addEventListener("mousemove", function (e) { findxy('move', e)}, false);
    document.addEventListener("mousedown", function (e) { findxy('down', e)}, false);
    document.addEventListener("mouseup",   function (e) { findxy('up',   e)}, false);
    document.addEventListener("mouseout",  function (e) { findxy('out',  e)}, false);
  }

  function onNewPage() {
    var pathname = window.location.pathname;
    var search = window.location.search;

    if (pathname != prev_pathname && pathname != '/photo.php') {
      if(changesMade) sendCanvas();
      posts = {};
      currentCanvas = null;
      prev_pathname = pathname;
      console.log('NEW WINDOW LOCATION.');

      if (window.location.pathname == '/') {
          if (isDrawing) {
            $('#sprayImage').trigger('click');
          }
          $('#sprayImage').hide();
      } else if (pathname.indexOf('groups') > -1) {
        $('#sprayImage').show();
        $(document).unbind("DOMNodeInserted");
        $(document).bind("DOMNodeInserted", function() {
          onDomSettled(500, function() {
            addGroupPosts();
          });
        });
      } else {
        $('#sprayImage').show();
        $(document).unbind("DOMNodeInserted");
        $(document).bind("DOMNodeInserted", function() {
          onDomSettled(500, function() {
            addProfilePosts();
          });
        });
      }
    } else if (search != prev_search && isDrawing) {
      if(changesMade) sendCanvas();
      prev_search = search;
      if (mainImageCanvas) {
        try {
          var canvas = mainImageCanvas.find('.myCanvas');
          delete posts[canvas[0].pid];
          canvas.remove();
          mainImageCanvas.find('.canvasImage').remove();
          mainImageCanvas.find('#shareBtn').remove();
        } catch(e){}
      }

      mainImageCanvas = null; 
      mainImageCanvas = $('.stage');
      $('.faceBox').remove();

      addPost($(mainImageCanvas[0]), search, true);

      if (!shareBtn) {
        shareBtn = document.createElement('img');
        shareBtn.id = 'shareButton';
        shareBtn.src = chrome.extension.getURL("images/share.png");
        shareBtn.style.cssText = 'width:38px;height:18px;top:10px;left:5px;'+
                                 'cursor:pointer;position:fixed;';
        $(shareBtn).click(function(e) {
          e.stopPropagation();
          share($('.stage'));
        });
        $('.stage')[0].appendChild(shareBtn);
      }
    }
  }
  // Timeline Posts.
  function addTimeLinePosts(e) {
    var posts = $(timelinePostsSelector);
    for (var i = 0; i < posts.length; i++) {
      var p = $(posts[i]);
      addPost(p, p.find('._5pcq').attr('href') );
    }
  }
  // Profile pages.
  function addProfilePosts(e) {
    console.log('Adding profilePosts');
    var posts = $(profilePostsSelector);
    for (var i = 0; i < posts.length; i++) {
      // var p = $($(posts[i]).parent()[0])
      // addPost(p, p.find('.uiLinkSubtle').attr('href') );
      var p = $(posts[i]);
      if (p.data && p.data('gt') && p.data('gt').contentid) {
        addPost(p, p.data('gt').contentid);
      }
    }
  }
  function addGroupPosts(e) {
    console.log('Adding Group Posts');
    var posts = $(groupPostsSelector).parent();
    for (var i = 0; i < posts.length; i++) {
      var p = $(posts[i]);
      if (p.data() && p.data('ft') && p.data('ft').id){
        addPost(p, p.data('ft').id);
      }
    }
  }

  function addPost(div, url, isSpotLight) {
    if (!url || !div) return;// console.log('No DIv or Url given');
    if (! div.width()) return;// console.log('OMG', div, url);

    var _pid = pidToURLPath(url);
    if (posts[_pid]) return;
    posts[_pid] = div[0];

    // console.log('Adding: ', _pid)// div);
    div.mouseover(function(event) {
      // console.log(_pid);
      var newCanvas = div.find('.myCanvas')[0];
      if (currentCanvas != newCanvas) {
        if (currentCanvas && changesMade) {
          sendCanvas();
          clearInterval(sendInterval);
        }
        changesMade = false;
        currentCanvas = newCanvas;
      }
    });

    
    addCanvas(_pid, div, isSpotLight);
    if (!isSpotLight) {
      div.bind('DOMSubtreeModified', function() {
        onDomSettled(1000, function() {
          var myCanvas = div.find('.myCanvas')[0];
          var width  = div.width() + 2*parseInt(div.css("padding-left"),10);
          var height = div.height() + 2*parseInt(div.css("padding-top"),10);
          
          // if (height > myCanvas.height) {
            var newCanvas = document.createElement('canvas');
            
            newCanvas.width = myCanvas.width;
            newCanvas.height = myCanvas.height;
            var ctx = newCanvas.getContext('2d');
            ctx.drawImage(myCanvas,0,0);

            var myImg = div.find('.canvasImage')[0];
            if (myImg) myImg.style.clip = 'rect(0px,'+width+'px,'+height+'px,0px)';

            myCanvas.height = height;
            myCanvas.width = width;

            ctx = myCanvas.getContext('2d');
            ctx.drawImage(newCanvas,0,0);

            console.log('new In ', url);
          // }
        });
      });
    }
  }

  function addCanvas(pid, p, isSpotLight) {
    var canvas = document.createElement('canvas');
    canvas.className = canvas.className + ' myCanvas';
    

    var width = p.width() + 2*parseInt(p.css("padding-left"),10);
    var height = p.height() + 2*parseInt(p.css("padding-top"),10);
    var top = 0;
    var left= 0;

    if (isSpotLight) {
      $(canvas).css('box-shadow',"0 0 40px #3b579d")
      var spotlight = $('.spotlight');
      var imgHeight = spotlight.height();
      var imgWidth = spotlight.width();
      top = (height - imgHeight)/2;
      left = (width - imgWidth)/2;
      height = imgHeight;
      width = imgWidth;
      $(canvas).click(function(e) {
        e.stopPropagation();
      });
    } else {
      $(canvas).css('box-shadow',"0 0 20px #3b579d");
    }
      
    canvas.style.position = "absolute";
    canvas.style.left = left+"px";
    canvas.style.top = top+"px";
    canvas.width = width;
    canvas.height = height;

    canvas.style.zIndex = 123;
    canvas.style.cursor = "crosshair";
    canvas.pid = pid;
    
    if (isSpotLight) {
      
    }

    var img = document.createElement("img");
    img.style.position = "absolute";
    img.style.left = left+"px";
    img.style.top = top+"px";
    img.width = width;
    img.height = height;
    
    img.crossOrigin = "anonymous";
    img.src = pidToFullUrl(pid);
    
    img.className += ' canvasImage';
    img.style.zIndex = 122;
    if(!isSpotLight) img.style.clip = 'rect(0px,'+width+'px,'+height+'px,0px)';
    // console.log('GETTING IMAGE', pidToFullUrl(pid));
    
    img.onerror = function(e) {
      // console.log('error');
      this.onerror = null;
      this.src = null;
      p[0].appendChild(canvas); 
      if(!isDrawing) $(canvas).hide();
    }
    img.onload = function() {

      // p[0].appendChild(shareBtn);

      var ctx=canvas.getContext("2d");
      ctx.drawImage(img, 0, 0, width, height);
      p[0].appendChild(canvas);
      
      if(!isDrawing) {
        $(canvas).hide();
        // if(shareBtn) $(shareBtn).hide();
      } else {
        $(canvas).show();
      } 
    }
  }

  function share(div) {
    var img = div.find('.spotlight')[0];
    var canvas = div.find('.myCanvas')[0];
    var width = canvas.width;
    var height = canvas.height;
    // var ctx = canvas.getContext("2d");
    var src = img.src;
    console.log('src:', src);

    var repeat = new Image;         
    repeat.crossOrigin = "Anonymous";
    repeat.onload = function() {
      var buffer = document.createElement('canvas');
      buffer.width = width;
      buffer.height = height;
      var ctx = buffer.getContext("2d");
      ctx.drawImage(repeat, 0, 0, width, height);
      ctx.drawImage(canvas, 0, 0, width, height);   
      var data = buffer.toDataURL();
      // var url = 'http://localhost:8888/CLASSES/IACD/FINAL/ChromeExtension/fbTest.html?foo=123'
      // var url = 'http://www.facebook.com/sharer.php?s=100&p[title]='+encodeURIComponent('this is a title') + '&p[summary]=' + encodeURIComponent('description here') + '&p[url]'
      // console.log('pid:', canvas.pid);
      shareImg(canvas.pid, data, function(data) {
        var u = domain+'share/'+data;
        // var u =  'http://fb-graffiti.com/'+'share/'+data
        // console.log('u:', u);
        var url = 'http://www.facebook.com/sharer/sharer.php?u='+encodeURIComponent(u);
        window.open(url, 'share graffiti', false);
      });

      // var url = 'http://www.facebook.com/sharer/sharer.php?u='+data;
      // window.open(data, 'share graffiti', false);
    }
    repeat.src = src;

  }

  function sendCanvas() {
    var path = pidToURLPath(currentCanvas.pid);
    var img = currentCanvas.toDataURL();
    sendImg(path, img);
    changesMade = false;
  }

  function bumpTimer() {
    if (sendInterval) clearInterval(sendInterval);
    sendInterval = setTimeout(sendCanvas, 4000);
  }

  function pidToFullUrl (pid) {
    var s3url = 'https://s3.amazonaws.com/facebookGraffiti/';
    var path = pidToURLPath(pid);
    var full = s3url+pidToURLPath(pid)+'.png';

    if (breakCache[path]) {
      return full + '?dummy='+(Math.random()+'').substr(2);
    } else {
      return full;
    }
    
  }

  function pidToURLPath (pid) {
    var front = "https://www.facebook.com/photo.php?fbid=";
    pid = (''+pid).replace(front, '').split('?stream_ref')[0].split('&type=1')[0].split('&set=')[0];
    
    if (pid.split('fbid=').length > 1) {
      pid = pid.split('fbid=')[1];
    }

    return (pid.replace(/\/|https|\?/g, ''));
  }
  function findxy(res, e) {
    if (!isDrawing) return;
    if (!currentCanvas) return;
    if (e.target != currentCanvas) return;

    var ctx = currentCanvas.getContext('2d');
    if (res == 'down') {
      prevX = currX;
      prevY = currY;

      currX = e.offsetX;//e.clientX - currentCanvas.offsetLeft;
      currY = e.offsetY;//e.clientY - currentCanvas.offsetTop;
   
      flag = true;
      // dot_flag = true;
      // if (dot_flag) {
      //   ctx.beginPath();
      //   ctx.fillStyle = selected.style['background-color'];
      //   ctx.fillRect(currX, currY, 2, 2);
      //   ctx.closePath();
      //   dot_flag = false;
      // }
    }
    if (flag && res == 'up' || res == "out") {
        flag = false;
    }
    if (res == 'move') {
      if (flag) {
        // ctx.beginPath();
       //  ctx.moveTo(this.X, this.Y);
       //  ctx.lineCap = 'round';
       //   ctx.lineWidth = 3;
       //  ctx.lineTo(e.pageX , e.pageY );
       //  ctx.strokeStyle = this.color;
       //  ctx.stroke();

       //   this.X = e.pageX ;
        // this.Y = e.pageY ;
        prevX = currX;
        prevY = currY;
        currX = e.offsetX;//e.clientX - currentCanvas.offsetLeft;
        currY = e.offsetY;//e.clientY - currentCanvas.offsetTop;
        draw(ctx);
      }
    }
  }
  var strokeWidth = 8;
  function draw(ctx) {
    bumpTimer();
    changesMade = true;
    ctx.beginPath();
    ctx.moveTo(prevX, prevY);
    ctx.lineTo(currX, currY);
    ctx.strokeStyle = selected.style['background-color'];
    ctx.lineCap = 'round';
    ctx.lineWidth = strokeWidth;
    ctx.stroke();
    ctx.closePath();
  }

  function newView() {
    if (window.location.origin != "https://www.facebook.com") {
      $(container).hide();
      return;
    }
    var split = window.location.pathname.split('/');
    var otherPages =['groups', 'events', 'messages'];
    if (window.location.pathname == '/') {
      return 'timeline';
    } else if (split.length == 2 && otherPages.indexOf(split[1]) == -1) {
      return 'other'
    }
  }
      // url: 'http://FB-Graffiti-1572262051.us-east-1.elb.amazonaws.com:3000/setImage/',
      
      // url: 'http://ec2-54-86-103-35.compute-1.amazonaws.com:3000/setImage/',

  function sendImg(path, img) {
    if (!path) return
    if (!img) return
    breakCache[path] = true;
    $.ajax({
      type:'POST',
      url: domain+'setImage/',
      data: {
        img:img,
        path:path,
        imgUrl: window.location.pathname
      },
      cache:false,
      error: function(data) {
        console.log("error sending image..");
        // alert('Oh no!\nThere was an error uploading your masterpeice!\nTry again in a few hours :(')
      }
    }); 
  }
  function shareImg(path, img, cb) {
    if (!path) return
    if (!img) return
    breakCache[path] = true;
    $.ajax({
      type:'POST',
      url: domain+'shareImage/',
      data: {
        img:img,
        path:path,
        imgUrl: window.location.pathname
      },
      cache:false,
      success:function(data) {
        if (cb) cb(data);
      },
      error: function(data) {
        console.log("error sending image..");
        // alert('Oh no!\nThere was an error uploading your masterpeice!\nTry again in a few hours :(')
      }
    }); 
  }
})();