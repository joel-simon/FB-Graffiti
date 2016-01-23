(function() {
  var DomCoolTest,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  DomCoolTest = (function() {
    function DomCoolTest(onCool, t) {
      this.onCool = onCool;
      this.t = t;
      this.warm = __bind(this.warm, this);
      this.timer = null;
    }

    DomCoolTest.prototype.warm = function() {
      if (this.timer != null) {
        clearTimeout(this.timer);
        this.timer = null;
      }
      return this.timer = setTimeout(((function(_this) {
        return function() {
          _this.timer = null;
          return _this.onCool();
        };
      })(this)), this.t);
    };

    DomCoolTest.prototype.isWarm = function() {
      return this.timer != null;
    };

    return DomCoolTest;

  })();

  if (window.fbg == null) {
    window.fbg = {};
  }

  window.fbg.DomCoolTest = DomCoolTest;

}).call(this);
(function() {
  fbg.DrawTools = (function() {
    function DrawTools() {
      var colorPicker, donate, downloadButton, drawButton, dropper, items, rangePicker, reportButton, selectors, showGraffitiButton, text, tip, utilities;
      this.selectorOpen = false;
      this.eyeDropping = false;
      this.container = $('<div>').css({
        height: 50,
        margin: 4,
        position: 'absolute',
        cursor: 'pointer'
      });
      selectors = $('<div>').css('float', 'left');
      utilities = $('<div>').css('float', 'left');
      selectors.hide();
      rangePicker = $('<input type="range" id="brushRange" value="40">').css({
        width: 60,
        float: 'left'
      }).click(function(e) {
        return e.stopPropagation();
      }).change((function(_this) {
        return function() {
          return _this.updateCursor();
        };
      })(this));
      dropper = $('<img>').attr({
        id: 'dropper',
        src: 'http://simpleicon.com/wp-content/uploads/eyedropper-64x64.png'
      }).css({
        float: 'left'
      }).click((function(_this) {
        return function() {
          var color;
          color = _this.eyeDropping ? 'white' : 'black';
          dropper.css('border-color', color);
          _this.eyeDropping = !_this.eyeDropping;
          return _this.updateCursor();
        };
      })(this));
      colorPicker = $("<input type='text'/>").attr({
        id: 'custom'
      }).css({
        float: 'left'
      }).prependTo(selectors).spectrum({
        color: "#000",
        change: (function(_this) {
          return function(c) {
            return _this.updateCursor();
          };
        })(this),
        show: (function(_this) {
          return function() {
            return _this.selectorOpen = true;
          };
        })(this),
        hide: (function(_this) {
          return function() {
            _this.selectorOpen = false;
            return _this.updateCursor();
          };
        })(this)
      });
      showGraffitiButton = $('<button id="toggleG">Hide Graffiti</button>').css({
        float: 'left',
        width: 80
      }).click(function() {
        if (fbg.showGraffiti) {
          $(this).text('Show');
          fbg.canvas.hide();
        } else {
          $(this).text('Hide graffiti');
          fbg.canvas.show();
        }
        return fbg.showGraffiti = !fbg.showGraffiti;
      });
      drawButton = $('<button id="toggleDrawing"></button>').text(fbg.drawing ? 'Stop' : 'Draw').css({
        float: 'left',
        width: 80
      }).click((function(_this) {
        return function() {
          if (fbg.drawing) {
            fbg.get.faceBoxes().show();
            drawButton.text('Draw');
            fbg.canvas.postToServer();
          } else {
            fbg.get.faceBoxes().hide();
            drawButton.text('Stop');
          }
          selectors.toggle();
          utilities.toggle();
          if (!fbg.showGraffiti && fbg.drawing === false) {
            showGraffitiButton.trigger('click');
          }
          fbg.drawing = !fbg.drawing;
          return _this.updateCursor();
        };
      })(this));
      reportButton = $('<button id="report">Report</button>').css({
        float: 'left',
        width: 80
      }).click((function(_this) {
        return function() {
          var data, report, text;
          text = 'Does this graffiti contain any: abuse, harrasment or egregiously offensive material? Remember, you can always remove graffiti from your own photos! For more information visit http://fbgraffiti.com/faq/';
          report = confirm(text);
          if (report) {
            data = {
              id: fbg.canvas.id
            };
            $.ajax({
              type: 'POST',
              url: "" + fbg.host + "report",
              data: data
            });
            return alert('It will be evaluated and potentially removed, thanks.');
          }
        };
      })(this));
      this.undoButton = $('<button id="undo" disabled>Undo</button>').css({
        float: 'left',
        width: 80
      }).click((function(_this) {
        return function() {
          fbg.canvas.undo();
          if (fbg.canvas.history.length === 0) {
            return _this.undoButton.prop("disabled", true);
          }
        };
      })(this));
      downloadButton = $('<a id="downlaod">Download</a>').css({
        float: 'left',
        width: 80,
        'margin-top': 2
      }).click(function() {
        alert('Tweet with #fbgraffiti or @fb_graffiti!');
        this.href = fbg.canvas["export"]();
        return this.download = fbg.canvas.id + '.png';
      });
      tip = $('<p></p>').css({
        position: 'absolute'
      });
      items = ['Hide graffiti to tag photos', 'Turn the entire extension on/off from the chrome extension button'];
      text = 'Tip: ' + items[Math.floor(Math.random() * items.length)];
      tip.text(text);
      donate = $('<a target="_blank" href="http://www.fbgraffiti.com/support">SUPPORT</a>').css({
        position: 'absolute',
        top: 25,
        left: 140
      });
      dropper.prependTo(selectors);
      rangePicker.prependTo(selectors);
      this.undoButton.appendTo(selectors);
      showGraffitiButton.appendTo(utilities);
      reportButton.appendTo(utilities);
      downloadButton.appendTo(utilities);
      drawButton.appendTo(this.container);
      selectors.appendTo(this.container);
      utilities.appendTo(this.container);
      this.container.prependTo($(document.body));
      fbg.mouse.addListener('mousemove', (function(_this) {
        return function(_arg) {
          var c, currX, currY, onCanvas;
          currX = _arg.currX, currY = _arg.currY, onCanvas = _arg.onCanvas;
          if (_this.eyeDropping && onCanvas) {
            c = fbg.canvas.getColor(currX, currY);
            return _this.setColor(c);
          }
        };
      })(this));
      fbg.mouse.addListener('mousedown', (function(_this) {
        return function(_arg) {
          var onCanvas;
          onCanvas = _arg.onCanvas;
          $('#custom').spectrum("hide");
          if (_this.eyeDropping && onCanvas) {
            return dropper.trigger('click');
          }
        };
      })(this));
      this.hide();
    }

    DrawTools.prototype.hide = function() {
      $('#custom').spectrum("hide");
      this.undoButton.prop("disabled", true);
      return this.container.hide();
    };

    DrawTools.prototype.show = function() {
      $('.rhcHeader').css('height', 50).prepend(this.container);
      $('#toggleG').text('Hide graffiti');
      this.updateCursor();
      return this.container.show();
    };

    DrawTools.prototype.setColor = function(c) {
      return $('#custom').spectrum('set', c);
    };

    DrawTools.prototype.color = function() {
      var t;
      t = $('#custom').spectrum('get');
      if (t != null) {
        return t.toRgbString();
      } else {
        return "rgba(255, 0, 0, 0)";
      }
    };

    DrawTools.prototype.size = function() {
      var _ref;
      return (parseInt((_ref = $('#brushRange')[0]) != null ? _ref.value : void 0) / 3) + 2;
    };

    DrawTools.prototype.updateCursor = function(color) {
      var ctx, cursor, size;
      if (!fbg.drawing) {
        return $('.canvas').css({
          'cursor': 'default'
        });
      } else if (this.eyeDropping) {
        return $('.canvas').css({
          'cursor': 'crosshair'
        });
      } else {
        cursor = document.createElement('canvas');
        ctx = cursor.getContext('2d');
        color = $('#custom').spectrum('get');
        size = this.size();
        cursor.width = size * 2;
        cursor.height = size * 2;
        ctx.beginPath();
        ctx.arc(size, size, size, 0, 2 * Math.PI, false);
        ctx.fillStyle = color.toRgbString();
        ctx.fill();
        ctx.lineWidth = 1;
        ctx.strokeStyle = color.getBrightness() > 100 ? '#000000' : '#FFFFFF';
        ctx.stroke();
        return $('.canvas').css({
          'cursor': "url(" + (cursor.toDataURL()) + ") " + size + " " + size + ", auto"
        });
      }
    };

    return DrawTools;

  })();

}).call(this);
(function() {
  fbg.FbgCanvas = (function() {
    function FbgCanvas(img, id, url) {
      var height, left, top, width;
      this.img = img;
      this.id = id;
      this.changesMade = false;
      this.img.addClass('hasCanvas');
      this.stage = $('.stage').first();
      this.owner = fbg.get.owner() || fbg.urlParser.owner(fbg.currentPage);
      this.history = [];
      top = "" + (Math.floor((this.stage.height() - this.img.height()) / 2)) + "px";
      left = "" + (Math.floor((this.stage.width() - this.img.width()) / 2)) + "px";
      width = this.img.width();
      height = this.img.height();
      this.canvas = $('<canvas>').attr({
        id: "canvas" + this.id,
        width: width,
        height: height
      }).css({
        position: 'absolute',
        top: top,
        left: left,
        cursor: "crosshair",
        'z-index': 2
      }).addClass('canvas').click(function(e) {
        console.log('getting click');
        return e.stopPropagation();
      });
      this.ctx = this.canvas[0].getContext('2d');
      this.graffitiImage = $('<img>').attr({
        src: url,
        id: "" + this.id + "img",
        'crossOrigin': 'anonymous'
      }).load((function(_this) {
        return function() {
          _this.img.addClass('hasGraffiti');
          return _this.ctx.drawImage(_this.graffitiImage[0], 0, 0, width, height);
        };
      })(this));
      this.createImgCopy((function(_this) {
        return function(_arg) {
          var canvas, ctx;
          canvas = _arg.canvas, ctx = _arg.ctx;
          _this.fbImgCtx = ctx;
          return _this.fbImgCanvas = canvas;
        };
      })(this));
    }

    FbgCanvas.prototype.saveState = function() {
      this.history.push(this.canvas[0].toDataURL());
      return fbg.drawTools.undoButton.prop("disabled", false);
    };

    FbgCanvas.prototype.undo = function() {
      var h, img, restore_state, w;
      restore_state = this.history.pop();
      if (restore_state == null) {
        return;
      }
      img = new Image;
      w = this.canvas[0].width;
      h = this.canvas[0].height;
      if (this.history.length === 0) {
        this.changesMade = false;
      }
      img.onload = (function(_this) {
        return function() {
          _this.ctx.clearRect(0, 0, w, h);
          return _this.ctx.drawImage(img, 0, 0, w, h);
        };
      })(this);
      img.src = restore_state;
      return null;
    };

    FbgCanvas.prototype.resize = function() {
      var height, width;
      width = this.img.width();
      height = this.img.height();
      this.canvas.attr({
        width: width,
        height: height
      });
      if (this.img.hasClass('hasGraffiti')) {
        return this.ctx.drawImage(this.graffitiImage[0], 0, 0, width, height);
      }
    };

    FbgCanvas.prototype.draw = function(_arg) {
      var currX, currY, prevX, prevY, r;
      prevX = _arg.prevX, prevY = _arg.prevY, currX = _arg.currX, currY = _arg.currY;
      if (fbg.drawTools.selectorOpen) {
        return;
      }
      this.changesMade = true;
      r = fbg.drawTools.size();
      this.ctx.beginPath();
      this.ctx.moveTo(prevX, prevY);
      this.ctx.lineTo(currX, currY);
      this.ctx.strokeStyle = fbg.drawTools.color();
      this.ctx.lineCap = 'round';
      this.ctx.lineWidth = r * 2;
      this.ctx.stroke();
      return this.ctx.closePath();
    };

    FbgCanvas.prototype.addTo = function(div) {
      return div.prepend(this.canvas);
    };

    FbgCanvas.prototype.remove = function() {
      var img;
      this.hide();
      if (this.changesMade) {
        img = this.canvas[0].toDataURL();
        this.postToServer(img);
        this.addToOtherCopies(img);
      }
      this.canvas.remove();
      fbg.drawTools.hide();
      this.img.removeClass('hasCanvas');
      return delete fbg.canvas;
    };

    FbgCanvas.prototype.hide = function() {
      return this.canvas.hide();
    };

    FbgCanvas.prototype.show = function() {
      return this.canvas.show();
    };

    FbgCanvas.prototype.postToServer = function(img) {
      var data, error;
      if (!this.changesMade) {
        return;
      }
      if (img == null) {
        img = this.canvas[0].toDataURL();
      }
      data = {
        id: this.id,
        img: img,
        url: this.img.attr('src'),
        owner: this.owner
      };
      error = function(XHR, err) {
        return console.log("There was an error posting to server " + err);
      };
      return $.ajax({
        type: 'POST',
        url: "" + fbg.host + "setImage",
        data: data,
        error: error
      });
    };

    FbgCanvas.prototype.addToOtherCopies = function(canvasImg) {
      var ctx, height, id, newImage, newImageCanvas, width;
      width = this.img.width();
      height = this.img.height();
      if (this.img.hasClass('hasGraffiti')) {
        newImageCanvas = $('<canvas>').attr({
          width: width,
          height: height
        });
        ctx = newImageCanvas[0].getContext('2d');
        ctx.drawImage(this.canvas[0], 0, 0, width, height);
        newImage = newImageCanvas[0].toDataURL();
        fbg.cache.add(this.id, newImage);
        return $(".img" + this.id).not('.spotlight').each(function() {
          var img;
          img = $(this);
          return img.attr({
            src: newImage
          });
        });
      } else {
        fbg.cache.add(this.id, canvasImg);
        id = this.id;
        return $(document.body).find('img').not('.hasGraffiti').not('.spotlight').each(function() {
          var img, _id;
          img = $(this);
          _id = fbg.urlParser.id(this.src);
          if (!_id) {
            return;
          }
          if (_id[1] === id) {
            return new fbg.FbgImg(img, id, canvasImg);
          }
        });
      }
    };


    /*
      Export the two canvas layers into one canvas.
     */

    FbgCanvas.prototype["export"] = function() {
      var canvas, ctx, h, w, _ref;
      canvas = document.createElement('canvas');
      ctx = canvas.getContext("2d");
      _ref = [this.img.width(), this.img.height()], w = _ref[0], h = _ref[1];
      canvas.width = w;
      canvas.height = h;
      console.log(this.fbImgCanvas[0], this.canvas[0]);
      ctx.drawImage(this.fbImgCanvas, 0, 0);
      ctx.drawImage(this.canvas[0], 0, 0);
      return canvas.toDataURL();
    };

    FbgCanvas.prototype.createImgCopy = function(callback) {
      var copy, src;
      src = this.img[0].src;
      copy = new Image;
      copy.crossOrigin = "Anonymous";
      copy.onload = (function(_this) {
        return function() {
          var canvas, ctx;
          canvas = document.createElement('canvas');
          canvas.width = _this.img.width();
          canvas.height = _this.img.height();
          ctx = canvas.getContext("2d");
          ctx.drawImage(copy, 0, 0, _this.img.width(), _this.img.height());
          return callback({
            canvas: canvas,
            ctx: ctx
          });
        };
      })(this);
      return copy.src = src;
    };

    FbgCanvas.prototype.getColor = function(x, y) {
      var a, b, g, r, _ref, _ref1;
      _ref = this.ctx.getImageData(x, y, 1, 1).data, r = _ref[0], g = _ref[1], b = _ref[2], a = _ref[3];
      if (a === 255) {
        return "rgb(" + r + ", " + g + ", " + b + ")";
      }
      _ref1 = this.fbImgCtx.getImageData(x, y, 1, 1).data, r = _ref1[0], g = _ref1[1], b = _ref1[2], a = _ref1[3];
      return "rgb(" + r + ", " + g + ", " + b + ")";
    };

    return FbgCanvas;

  })();

}).call(this);
(function() {
  var FbgImg;

  FbgImg = (function() {
    function FbgImg(img, key, url) {
      var css, domElem;
      img.addClass('hasGraffiti');
      css = {
        position: 'absolute',
        'z-index': 3
      };
      img.parent().css({
        'overflow': 'hidden'
      });
      css.left = img.css('left');
      if (img.css('top') !== '0px') {
        css.top = img.css('top');
      }
      if (img.css('marginLeft') !== '0px') {
        css.marginLeft = img.css('marginLeft');
      }
      if (img.css('marginTop') !== '0px') {
        css.marginTop = img.css('marginTop');
      }
      domElem = $('<img>').addClass('img' + key).css(css).load(function(e) {
        img.parent().prepend($(this));
        if (img.hasClass('profilePic')) {
          if ($(this).css('height') > $(this).css('width')) {
            return $(this).css('width', img.outerWidth());
          } else {
            $(this).css('height', img.outerHeight());
            return $(this).css('left', (img.outerWidth() - $(this).width()) / 2);
          }
        } else {
          return $(this).css('width', img.outerWidth());
        }
      }).error(function(e) {
        img.removeClass('hasGraffiti');
        return fbg.cache.doesntExist(key);
      }).attr({
        src: url
      });
    }

    return FbgImg;

  })();

  if (window.fbg == null) {
    window.fbg = {};
  }

  window.fbg.FbgImg = FbgImg;

}).call(this);
(function() {
  var ImageCache;

  ImageCache = (function() {
    function ImageCache() {
      this.forced = {};
      this.local = {};
    }

    ImageCache.prototype["break"] = function(id) {
      this.forced[id] = true;
      return localStorage.setItem("fbgEmpty:" + id, null);
    };

    ImageCache.prototype.add = function(id, url) {
      return this.local[id] = url;
    };

    ImageCache.prototype.doesntExist = function(id) {
      return localStorage.setItem("fbgEmpty:" + id, Math.floor(Date.now() / 1000));
    };

    ImageCache.prototype.past24Hours = function(t) {
      return t > (Math.floor(Date.now() / 1000)) - 24 * 60 * 60;
    };

    ImageCache.prototype.idToUrl = function(id) {
      var isEmpty, q, s3Url;
      s3Url = "https://s3.amazonaws.com/facebookGraffiti/";
      isEmpty = localStorage.getItem("fbgEmpty:" + id);
      if (this.local[id] != null) {
        return this.local[id];
      }
      if ((isEmpty != null) && this.past24Hours(isEmpty)) {
        return null;
      }
      if (this.forced[id]) {
        q = "?dummy=" + ((Math.random() + '').substr(2));
        this.forced[id] = false;
      }
      return "" + s3Url + id + ".png" + (q || '');
    };

    return ImageCache;

  })();

  if (window.fbg == null) {
    window.fbg = {};
  }

  window.fbg.ImageCache = ImageCache;

}).call(this);
(function() {
  var currX, currY, dragging, onMouse, prevX, prevY;

  prevX = 0;

  currX = 0;

  prevY = 0;

  currY = 0;

  dragging = null;

  document.addEventListener("mousemove", (function(e) {
    return onMouse('move', e);
  }), false);

  document.addEventListener("mousedown", (function(e) {
    return onMouse('down', e);
  }), false);

  document.addEventListener("mouseup", (function(e) {
    return onMouse('up', e);
  }), false);

  document.addEventListener("mouseout", (function(e) {
    return onMouse('out', e);
  }), false);

  if (window.fbg == null) {
    window.fbg = {};
  }

  onMouse = function(eventType, e) {
    var onCanvas, options;
    if (!fbg.canvas) {
      return;
    }
    onCanvas = e.target === fbg.canvas.canvas[0];
    if (eventType === 'down') {
      prevX = currX;
      prevY = currY;
      currX = e.offsetX;
      currY = e.offsetY;
      dragging = true;
      options = {
        currX: currX,
        currY: currY,
        prevX: prevX,
        prevY: prevY,
        onCanvas: onCanvas
      };
      fbg.mouse.emitEvent('mousedown', [options]);
    }
    if (dragging && eventType === 'up' || dragging && eventType === "out") {
      fbg.mouse.emitEvent('mouseup', [
        {
          dragging: dragging
        }
      ]);
      dragging = false;
    }
    if (eventType === 'move') {
      prevX = currX;
      prevY = currY;
      currX = e.offsetX;
      currY = e.offsetY;
      options = {
        currX: currX,
        currY: currY,
        prevX: prevX,
        prevY: prevY,
        onCanvas: onCanvas,
        dragging: dragging
      };
      return fbg.mouse.emitEvent('mousemove', [options]);
    }
  };

}).call(this);
(function() {
  fbg.createNotif = function() {
    var countBox, countText, createIframe, data, flyout, haveIframe, id, iframeCss, jewel, jewelButton, jewelSrc, jewelSrcWhite, lastLogin, left, parent, picker, visible, width;
    data = {};
    parent = $('#fbRequestsJewel').parent();
    jewelSrc = fbg.imgHost + 'sprayIcon.png';
    jewelSrcWhite = fbg.imgHost + 'sprayIconWhite.png';
    visible = false;
    jewelButton = $('<div>').addClass('_4962');
    jewel = $('<img />', {
      src: jewelSrc
    });
    jewelButton.append(jewel);
    countBox = $('<div />').css({
      position: 'absolute',
      top: -4,
      left: 20,
      'background-color': 'red',
      height: 20,
      'border-radius': 3,
      display: 'none'
    });
    countText = $('<p>3</p>').css({
      color: 'white',
      margin: 4
    });
    countBox.append(countText);
    jewelButton.append(countBox);
    width = 430;
    left = -200;
    flyout = $('<div>').attr({}).css({
      'z-index': 10,
      position: 'absolute',
      'margin-top': 3
    }).hide();
    picker = $('<div><h1>Graffiti on your photos.</h1></div>').css({
      position: 'relative',
      left: left,
      width: width,
      'background-color': 'white',
      'z-index': 11,
      'border-left-style': 'solid',
      'border-color': 'grey',
      'border-width': 2
    }).appendTo(flyout);
    iframeCss = {
      width: width,
      height: 500,
      position: 'relative',
      left: left,
      'background-color': 'white',
      'border-top-style': 'none'
    };
    haveIframe = false;
    createIframe = function() {
      var myPhotos;
      if (haveIframe) {
        return;
      }
      console.log('here', fbg.host, fbg.urlParser.myId());
      myPhotos = $('<iframe />', {
        src: fbg.host + 'browse?u=' + fbg.urlParser.myId()
      }).css(iframeCss).appendTo(flyout);
      return haveIframe = true;
    };
    jewelButton.append(flyout);
    parent.prepend(jewelButton);
    $('#myG').click(function() {
      myPhotos.show();
      return global.hide();
    });
    $('#globalG').click(function() {
      myPhotos.hide();
      return global.show();
    });
    jewelButton.click(function() {
      countBox.hide();
      if (visible) {
        jewel.attr({
          src: jewelSrc
        });
        flyout.hide();
      } else {
        createIframe();
        jewel.attr({
          src: jewelSrcWhite
        });
        flyout.show();
      }
      return visible = !visible;
    });
    $('.jewelButton').click(function() {
      jewelButton.attr({
        src: jewelSrc
      });
      return flyout.hide();
    });
    console.log('Last login', localStorage.getItem("FbgLastLogin"));
    lastLogin = localStorage.getItem("FbgLastLogin");
    localStorage.setItem("FbgLastLogin", new Date());
    if (lastLogin != null) {
      lastLogin = lastLogin != null ? lastLogin.split(' ').join('_') : void 0;
      id = fbg.urlParser.myId();
      return $.get("" + fbg.host + "notifCount?id=" + id + "&last=" + lastLogin, function(data) {
        if (parseInt(data) > 0) {
          countText.text(data);
          jewel.attr({
            src: jewelSrcWhite
          });
          return countBox.show();
        }
      });
    }
  };

}).call(this);

/*
Spectrum Colorpicker v1.5.2
https://github.com/bgrins/spectrum
Author: Brian Grinstead
License: MIT
 */

(function() {
  var node, style;

  style = "\n#container {\n  width: 100%;\n}\n\n.page {\n  height: 55px;\n}\n\n.page img {\n  float: right;\n  margin-right: 10px;\n}\n\n.page p {\n  color: #3b5998;\n  font-weight: bold;\n  margin-left: 20px;\n  float: left;\n}\n\n#dropper {\n    border-style: solid;\n    width: 32px;\n    height: 32px;\n    border-color: white;\n    border-width : 1px;\n}\n\n# #dropper:hover {\n#     border-color: black;\n# }\n\n#dropper:active {\n    border-color: black;\n}\n\n.sp-container {\n    position:absolute;\n    top:0;\n    left:0;\n    display:inline-block;\n    *display: inline;\n    *zoom: 1;\n    /* https://github.com/bgrins/spectrum/issues/40 */\n    z-index: 9999994;\n    overflow: hidden;\n}\n.sp-container.sp-flat {\n    position: relative;\n}\n\n/* Fix for * { box-sizing: border-box; } */\n.sp-container,\n.sp-container * {\n    -webkit-box-sizing: content-box;\n       -moz-box-sizing: content-box;\n            box-sizing: content-box;\n}\n\n/* http://ansciath.tumblr.com/post/7347495869/css-aspect-ratio */\n.sp-top {\n  position:relative;\n  width: 100%;\n  display:inline-block;\n}\n.sp-top-inner {\n   position:absolute;\n   top:0;\n   left:0;\n   bottom:0;\n   right:0;\n}\n.sp-color {\n    position: absolute;\n    top:0;\n    left:0;\n    bottom:0;\n    right:20%;\n}\n.sp-hue {\n    position: absolute;\n    top:0;\n    right:0;\n    bottom:0;\n    left:84%;\n    height: 100%;\n}\n\n.sp-clear-enabled .sp-hue {\n    top:33px;\n    height: 77.5%;\n}\n\n.sp-fill {\n    padding-top: 80%;\n}\n.sp-sat, .sp-val {\n    position: absolute;\n    top:0;\n    left:0;\n    right:0;\n    bottom:0;\n}\n\n.sp-alpha-enabled .sp-top {\n    margin-bottom: 18px;\n}\n.sp-alpha-enabled .sp-alpha {\n    display: block;\n}\n.sp-alpha-handle {\n    position:absolute;\n    top:-4px;\n    bottom: -4px;\n    width: 6px;\n    left: 50%;\n    cursor: pointer;\n    border: 1px solid black;\n    background: white;\n    opacity: .8;\n}\n.sp-alpha {\n    display: none;\n    position: absolute;\n    bottom: -14px;\n    right: 0;\n    left: 0;\n    height: 8px;\n}\n.sp-alpha-inner {\n    border: solid 1px #333;\n}\n\n.sp-clear {\n    display: none;\n}\n\n.sp-clear.sp-clear-display {\n    background-position: center;\n}\n\n.sp-clear-enabled .sp-clear {\n    display: block;\n    position:absolute;\n    top:0px;\n    right:0;\n    bottom:0;\n    left:84%;\n    height: 28px;\n}\n\n/* Dont allow text selection */\n.sp-container, .sp-replacer, .sp-preview, .sp-dragger, .sp-slider, .sp-alpha, .sp-clear, .sp-alpha-handle, .sp-container.sp-dragging .sp-input, .sp-container button  {\n    -webkit-user-select:none;\n    -moz-user-select: -moz-none;\n    -o-user-select:none;\n    user-select: none;\n}\n\n.sp-container.sp-input-disabled .sp-input-container {\n    display: none;\n}\n.sp-container.sp-buttons-disabled .sp-button-container {\n    display: none;\n}\n.sp-container.sp-palette-buttons-disabled .sp-palette-button-container {\n    display: none;\n}\n.sp-palette-only .sp-picker-container {\n    display: none;\n}\n.sp-palette-disabled .sp-palette-container {\n    display: none;\n}\n\n.sp-initial-disabled .sp-initial {\n    display: none;\n}\n\n\n/* Gradients for hue, saturation and value instead of images.  Not pretty... but it works */\n.sp-sat {\n    background-image: -webkit-gradient(linear,  0 0, 100% 0, from(#FFF), to(rgba(204, 154, 129, 0)));\n    background-image: -webkit-linear-gradient(left, #FFF, rgba(204, 154, 129, 0));\n    background-image: -moz-linear-gradient(left, #fff, rgba(204, 154, 129, 0));\n    background-image: -o-linear-gradient(left, #fff, rgba(204, 154, 129, 0));\n    background-image: -ms-linear-gradient(left, #fff, rgba(204, 154, 129, 0));\n    background-image: linear-gradient(to right, #fff, rgba(204, 154, 129, 0));\n    -ms-filter: \"progid:DXImageTransform.Microsoft.gradient(GradientType = 1, startColorstr=#FFFFFFFF, endColorstr=#00CC9A81)\";\n    filter : progid:DXImageTransform.Microsoft.gradient(GradientType = 1, startColorstr='#FFFFFFFF', endColorstr='#00CC9A81');\n}\n.sp-val {\n    background-image: -webkit-gradient(linear, 0 100%, 0 0, from(#000000), to(rgba(204, 154, 129, 0)));\n    background-image: -webkit-linear-gradient(bottom, #000000, rgba(204, 154, 129, 0));\n    background-image: -moz-linear-gradient(bottom, #000, rgba(204, 154, 129, 0));\n    background-image: -o-linear-gradient(bottom, #000, rgba(204, 154, 129, 0));\n    background-image: -ms-linear-gradient(bottom, #000, rgba(204, 154, 129, 0));\n    background-image: linear-gradient(to top, #000, rgba(204, 154, 129, 0));\n    -ms-filter: \"progid:DXImageTransform.Microsoft.gradient(startColorstr=#00CC9A81, endColorstr=#FF000000)\";\n    filter : progid:DXImageTransform.Microsoft.gradient(startColorstr='#00CC9A81', endColorstr='#FF000000');\n}\n\n.sp-hue {\n    background: -moz-linear-gradient(top, #ff0000 0%, #ffff00 17%, #00ff00 33%, #00ffff 50%, #0000ff 67%, #ff00ff 83%, #ff0000 100%);\n    background: -ms-linear-gradient(top, #ff0000 0%, #ffff00 17%, #00ff00 33%, #00ffff 50%, #0000ff 67%, #ff00ff 83%, #ff0000 100%);\n    background: -o-linear-gradient(top, #ff0000 0%, #ffff00 17%, #00ff00 33%, #00ffff 50%, #0000ff 67%, #ff00ff 83%, #ff0000 100%);\n    background: -webkit-gradient(linear, left top, left bottom, from(#ff0000), color-stop(0.17, #ffff00), color-stop(0.33, #00ff00), color-stop(0.5, #00ffff), color-stop(0.67, #0000ff), color-stop(0.83, #ff00ff), to(#ff0000));\n    background: -webkit-linear-gradient(top, #ff0000 0%, #ffff00 17%, #00ff00 33%, #00ffff 50%, #0000ff 67%, #ff00ff 83%, #ff0000 100%);\n    background: linear-gradient(to bottom, #ff0000 0%, #ffff00 17%, #00ff00 33%, #00ffff 50%, #0000ff 67%, #ff00ff 83%, #ff0000 100%);\n}\n\n/* IE filters do not support multiple color stops.\n   Generate 6 divs, line them up, and do two color gradients for each.\n   Yes, really.\n */\n.sp-1 {\n    height:17%;\n    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff0000', endColorstr='#ffff00');\n}\n.sp-2 {\n    height:16%;\n    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffff00', endColorstr='#00ff00');\n}\n.sp-3 {\n    height:17%;\n    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#00ff00', endColorstr='#00ffff');\n}\n.sp-4 {\n    height:17%;\n    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#00ffff', endColorstr='#0000ff');\n}\n.sp-5 {\n    height:16%;\n    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#0000ff', endColorstr='#ff00ff');\n}\n.sp-6 {\n    height:17%;\n    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff00ff', endColorstr='#ff0000');\n}\n\n.sp-hidden {\n    display: none !important;\n}\n\n/* Clearfix hack */\n.sp-cf:before, .sp-cf:after { content: \"\"; display: table; }\n.sp-cf:after { clear: both; }\n.sp-cf { *zoom: 1; }\n\n/* Mobile devices, make hue slider bigger so it is easier to slide */\n@media (max-device-width: 480px) {\n    .sp-color { right: 40%; }\n    .sp-hue { left: 63%; }\n    .sp-fill { padding-top: 60%; }\n}\n.sp-dragger {\n   border-radius: 5px;\n   height: 5px;\n   width: 5px;\n   border: 1px solid #fff;\n   background: #000;\n   cursor: pointer;\n   position:absolute;\n   top:0;\n   left: 0;\n}\n.sp-slider {\n    position: absolute;\n    top:0;\n    cursor:pointer;\n    height: 3px;\n    left: -1px;\n    right: -1px;\n    border: 1px solid #000;\n    background: white;\n    opacity: .8;\n}\n\n/*\nTheme authors:\nHere are the basic themeable display options (colors, fonts, global widths).\nSee http://bgrins.github.io/spectrum/themes/ for instructions.\n*/\n\n.sp-container {\n    border-radius: 0;\n    background-color: #ECECEC;\n    border: solid 1px #f0c49B;\n    padding: 0;\n}\n.sp-container, .sp-container button, .sp-container input, .sp-color, .sp-hue, .sp-clear {\n    font: normal 12px \"Lucida Grande\", \"Lucida Sans Unicode\", \"Lucida Sans\", Geneva, Verdana, sans-serif;\n    -webkit-box-sizing: border-box;\n    -moz-box-sizing: border-box;\n    -ms-box-sizing: border-box;\n    box-sizing: border-box;\n}\n.sp-top {\n    margin-bottom: 3px;\n}\n.sp-color, .sp-hue, .sp-clear {\n    border: solid 1px #666;\n}\n\n/* Input */\n.sp-input-container {\n    float:right;\n    width: 100px;\n    margin-bottom: 4px;\n}\n.sp-initial-disabled  .sp-input-container {\n    width: 100%;\n}\n.sp-input {\n   font-size: 12px !important;\n   border: 1px inset;\n   padding: 4px 5px;\n   margin: 0;\n   width: 100%;\n   background:transparent;\n   border-radius: 3px;\n   color: #222;\n}\n.sp-input:focus  {\n    border: 1px solid orange;\n}\n.sp-input.sp-validation-error {\n    border: 1px solid red;\n    background: #fdd;\n}\n.sp-picker-container , .sp-palette-container {\n    float:left;\n    position: relative;\n    padding: 10px;\n    padding-bottom: 300px;\n    margin-bottom: -290px;\n}\n.sp-picker-container {\n    width: 172px;\n    border-left: solid 1px #fff;\n}\n\n/* Palettes */\n.sp-palette-container {\n    border-right: solid 1px #ccc;\n}\n\n.sp-palette-only .sp-palette-container {\n    border: 0;\n}\n\n.sp-palette .sp-thumb-el {\n    display: block;\n    position:relative;\n    float:left;\n    width: 24px;\n    height: 15px;\n    margin: 3px;\n    cursor: pointer;\n    border:solid 2px transparent;\n}\n.sp-palette .sp-thumb-el:hover, .sp-palette .sp-thumb-el.sp-thumb-active {\n    border-color: orange;\n}\n.sp-thumb-el {\n    position:relative;\n}\n\n/* Initial */\n.sp-initial {\n    float: left;\n    border: solid 1px #333;\n}\n.sp-initial span {\n    width: 30px;\n    height: 25px;\n    border:none;\n    display:block;\n    float:left;\n    margin:0;\n}\n\n.sp-initial .sp-clear-display {\n    background-position: center;\n}\n\n/* Buttons */\n.sp-palette-button-container,\n.sp-button-container {\n    float: right;\n}\n\n/* Replacer (the little preview div that shows up instead of the <input>) */\n.sp-replacer {\n    # position: absolute;\n    float: left;\n    z-index: 999;\n    margin:0;\n    overflow:hidden;\n    cursor:pointer;\n    padding: 4px;\n    display:inline-block;\n    *zoom: 1;\n    *display: inline;\n    border: solid 1px #91765d;\n    background: #eee;\n    color: #333;\n    vertical-align: middle;\n}\n.sp-replacer:hover, .sp-replacer.sp-active {\n    border-color: #F0C49B;\n    color: #111;\n}\n.sp-replacer.sp-disabled {\n    cursor:default;\n    border-color: silver;\n    color: silver;\n}\n.sp-dd {\n    padding: 2px 0;\n    height: 16px;\n    line-height: 16px;\n    float:left;\n    font-size:10px;\n}\n.sp-preview {\n    position:relative;\n    width:25px;\n    height: 20px;\n    border: solid 1px #222;\n    margin-right: 5px;\n    float:left;\n    z-index: 0;\n}\n\n.sp-palette {\n    *width: 220px;\n    max-width: 220px;\n}\n.sp-palette .sp-thumb-el {\n    width:16px;\n    height: 16px;\n    margin:2px 1px;\n    border: solid 1px #d0d0d0;\n}\n\n.sp-container {\n    padding-bottom:0;\n}\n\n\n/* Buttons: http://hellohappy.org/css3-buttons/ */\n.sp-container button {\n  background-color: #eeeeee;\n  background-image: -webkit-linear-gradient(top, #eeeeee, #cccccc);\n  background-image: -moz-linear-gradient(top, #eeeeee, #cccccc);\n  background-image: -ms-linear-gradient(top, #eeeeee, #cccccc);\n  background-image: -o-linear-gradient(top, #eeeeee, #cccccc);\n  background-image: linear-gradient(to bottom, #eeeeee, #cccccc);\n  border: 1px solid #ccc;\n  border-bottom: 1px solid #bbb;\n  border-radius: 3px;\n  color: #333;\n  font-size: 14px;\n  line-height: 1;\n  padding: 5px 4px;\n  text-align: center;\n  text-shadow: 0 1px 0 #eee;\n  vertical-align: middle;\n}\n.sp-container button:hover {\n    background-color: #dddddd;\n    background-image: -webkit-linear-gradient(top, #dddddd, #bbbbbb);\n    background-image: -moz-linear-gradient(top, #dddddd, #bbbbbb);\n    background-image: -ms-linear-gradient(top, #dddddd, #bbbbbb);\n    background-image: -o-linear-gradient(top, #dddddd, #bbbbbb);\n    background-image: linear-gradient(to bottom, #dddddd, #bbbbbb);\n    border: 1px solid #bbb;\n    border-bottom: 1px solid #999;\n    cursor: pointer;\n    text-shadow: 0 1px 0 #ddd;\n}\n.sp-container button:active {\n    border: 1px solid #aaa;\n    border-bottom: 1px solid #888;\n    -webkit-box-shadow: inset 0 0 5px 2px #aaaaaa, 0 1px 0 0 #eeeeee;\n    -moz-box-shadow: inset 0 0 5px 2px #aaaaaa, 0 1px 0 0 #eeeeee;\n    -ms-box-shadow: inset 0 0 5px 2px #aaaaaa, 0 1px 0 0 #eeeeee;\n    -o-box-shadow: inset 0 0 5px 2px #aaaaaa, 0 1px 0 0 #eeeeee;\n    box-shadow: inset 0 0 5px 2px #aaaaaa, 0 1px 0 0 #eeeeee;\n}\n.sp-cancel {\n    font-size: 11px;\n    color: #d93f3f !important;\n    margin:0;\n    padding:2px;\n    margin-right: 5px;\n    vertical-align: middle;\n    text-decoration:none;\n\n}\n.sp-cancel:hover {\n    color: #d93f3f !important;\n    text-decoration: underline;\n}\n\n\n.sp-palette span:hover, .sp-palette span.sp-thumb-active {\n    border-color: #000;\n}\n\n.sp-preview, .sp-alpha, .sp-thumb-el {\n    position:relative;\n    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAIAAADZF8uwAAAAGUlEQVQYV2M4gwH+YwCGIasIUwhT25BVBADtzYNYrHvv4gAAAABJRU5ErkJggg==);\n}\n.sp-preview-inner, .sp-alpha-inner, .sp-thumb-inner {\n    display:block;\n    position:absolute;\n    top:0;left:0;bottom:0;right:0;\n}\n\n.sp-palette .sp-thumb-inner {\n    background-position: 50% 50%;\n    background-repeat: no-repeat;\n}\n\n.sp-palette .sp-thumb-light.sp-thumb-active .sp-thumb-inner {\n    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAIVJREFUeNpiYBhsgJFMffxAXABlN5JruT4Q3wfi/0DsT64h8UD8HmpIPCWG/KemIfOJCUB+Aoacx6EGBZyHBqI+WsDCwuQ9mhxeg2A210Ntfo8klk9sOMijaURm7yc1UP2RNCMbKE9ODK1HM6iegYLkfx8pligC9lCD7KmRof0ZhjQACDAAceovrtpVBRkAAAAASUVORK5CYII=);\n}\n\n.sp-palette .sp-thumb-dark.sp-thumb-active .sp-thumb-inner {\n    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAadEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjEwMPRyoQAAAMdJREFUOE+tkgsNwzAMRMugEAahEAahEAZhEAqlEAZhEAohEAYh81X2dIm8fKpEspLGvudPOsUYpxE2BIJCroJmEW9qJ+MKaBFhEMNabSy9oIcIPwrB+afvAUFoK4H0tMaQ3XtlrggDhOVVMuT4E5MMG0FBbCEYzjYT7OxLEvIHQLY2zWwQ3D+9luyOQTfKDiFD3iUIfPk8VqrKjgAiSfGFPecrg6HN6m/iBcwiDAo7WiBeawa+Kwh7tZoSCGLMqwlSAzVDhoK+6vH4G0P5wdkAAAAASUVORK5CYII=);\n}\n\n.sp-clear-display {\n    background-repeat:no-repeat;\n    background-position: center;\n    background-image: url(data:image/gif;base64,R0lGODlhFAAUAPcAAAAAAJmZmZ2dnZ6enqKioqOjo6SkpKWlpaampqenp6ioqKmpqaqqqqurq/Hx8fLy8vT09PX19ff39/j4+Pn5+fr6+vv7+wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAAP8ALAAAAAAUABQAAAihAP9FoPCvoMGDBy08+EdhQAIJCCMybCDAAYUEARBAlFiQQoMABQhKUJBxY0SPICEYHBnggEmDKAuoPMjS5cGYMxHW3IiT478JJA8M/CjTZ0GgLRekNGpwAsYABHIypcAgQMsITDtWJYBR6NSqMico9cqR6tKfY7GeBCuVwlipDNmefAtTrkSzB1RaIAoXodsABiZAEFB06gIBWC1mLVgBa0AAOw==);\n}";

  node = document.createElement('style');

  node.innerHTML = style;

  document.body.appendChild(node);

}).call(this);
(function() {
  var lolHardcoded;

  lolHardcoded = '<head><title>Most Graffitied Pages in Last Week</title></head><body><div id="container"><div class="page"><a href="https://www.facebook.com/MarineLePen" title=""><p>Marine Le Pen</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/c0.7.50.50/p50x50/10428478_988861374463520_4719012667447954388_n.jpg?oh=472c53d776316fd0769a6ff4528f2db6&amp;oe=555F3811&amp;__gda__=1431957301_54341b48a56e7078c055202ea790c431" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/dieudonneofficiel" title=""><p>Dieudonné Officiel</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/10403072_10152763141099006_8149730862439609461_n.jpg?oh=50030b095f44ca86b2a54e2c2b00b4d7&amp;oe=554EF12D&amp;__gda__=1433008424_09bc5845a57850083d8018e591b3796f" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/Officialemilyratajkowski" title=""><p>Emily Ratajkowski</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p50x50/10355384_673971456047685_4272295041462813592_n.jpg?oh=0f78486a0e24be88d219f96c93a3e27e&amp;oe=559579E8&amp;__gda__=1435694478_df669d538928547b8ed9200ab380c288" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/LeGrandMix" title=""><p>Radio Nova</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/p50x50/1457745_10151864896601843_2044688803_n.jpg?oh=2ac7310f5c15300867f09de8e014389a&amp;oe=55920FA5&amp;__gda__=1435548423_b4de4ad0cf24e604978a2c7cdb65d370" class="profile hasGraffiti"/></a></div><div class="page"><a href="https://www.facebook.com/VICE" title=""><p>VICE</p><img src="https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p50x50/1503347_898321190201140_6093099325167080818_n.jpg?oh=00fb23d0bcdab70fe6c2a69e5c173fe7&amp;oe=556A85D2&amp;__gda__=1432399815_6efd5ff62901a6246845edb2a54add98" class="profile hasGraffiti"/></a></div></div></body>';

  window.fbg.addTrending = function() {
    if ($('#pagelet_trending_graffiti')[0] != null) {
      return;
    }
    return $.get(fbg.topPagesUrl, function(content) {
      return $('.rightColumnWrapper').append($('<div class="pagelet" id="pagelet_trending_graffiti"> <div class="_5mym"> <div class="uiHeader uiHeaderTopBorder pbs _2w2d"> <div class="clearfix uiHeaderTop"> <div><h6 class="uiHeaderTitle"> <a class="_2w2e _24gw" target="_blank"  href="#" role="button" id="u_0_1k"> Trending Graffiti Pages </a> </h6></div></div></div> <div class="_5my7">' + content, +'</div> </div> </div>'));
    });
  };

}).call(this);
(function() {
  var convertAllImages, trackChanges;

  if (fbg.host == null) {
    fbg.host = 'https://fb-graffiti.com/';
  }

  fbg.imgHost = 'http://fbgraffiti.com/extensionimages/';

  fbg.topPagesUrl = 'https://s3.amazonaws.com/fbgsource/topPages.html';

  fbg.drawing = false;

  fbg.showGraffiti = true;

  fbg.urlParser = {
    userImage: function(src) {
      return src.match(/(profile).*\/[0-9]+_([0-9]+)_[0-9]+/);
    },
    userContent: function(src) {
      return src.match(/(sphotos|scontent).*\/[0-9]+_([0-9]+)_[0-9]+/);
    },
    photoPage: function(src) {
      return src.match(/www.facebook.com\/photo.php?/) || src.match(/www.facebook.com\/.*\/photos/);
    },
    id: function(src) {
      return src.match(/\/[0-9]+_([0-9]+)_[0-9]+/);
    },
    stupidCroppedPhoto: function(src) {
      return src.match(/p\d+x\d+/);
    },
    myId: function() {
      var s;
      s = $("img[id^=profile_pic_header]")[0].id;
      return s != null ? s.match(/_([0-9]+)/)[1] : void 0;
    },
    owner: function(url) {
      var a, b;
      a = url.match(/t\.([0-9]+)/);
      b = url.match(/[0-9]+\.[0-9]+\.([0-9]+)/);
      return (a && a[1]) || (b && b[1]) || null;
    }
  };

  fbg.get = {
    mainImg: function() {
      return $('.spotlight');
    },
    faceBoxes: function() {
      return $('.faceBox');
    },
    photoUi: function() {
      return $('.stageActions, .faceBox, .highlightPager');
    },
    profileAndCover: function() {
      return $('.profilePic, .coverPhotoImg');
    },
    owner: function() {
      var ownerId, url, _ref;
      url = (_ref = $('#fbPhotoSnowliftAuthorName').children().data()) != null ? _ref.hovercard : void 0;
      if (url == null) {
        return null;
      }
      ownerId = url.match(/id=([0-9]+)/);
      if (ownerId == null) {
        return null;
      }
      return ownerId[1];
    }
  };

  fbg.isCoverPhoto = function(img) {
    return img.parent().parent().attr('id') === 'fbProfileCover';
  };

  fbg.onPageLoad = function() {
    var id, mainImg, onHomePage, onNewPage, onPhotoPage, url, _ref;
    onNewPage = location.href !== fbg.currentPage;
    onPhotoPage = fbg.urlParser.photoPage(location.href) != null;
    onHomePage = location.pathname === '/';
    fbg.currentPage = location.href;
    if (onNewPage) {
      if (typeof fbg !== "undefined" && fbg !== null) {
        if ((_ref = fbg.canvas) != null) {
          _ref.remove();
        }
      }
      if (onPhotoPage) {
        mainImg = fbg.get.mainImg();
        id = fbg.urlParser.userContent(mainImg[0].src)[2];
        fbg.cache["break"](id);
        url = fbg.cache.idToUrl(id);
        fbg.canvas = new fbg.FbgCanvas(mainImg, id, url);
        fbg.canvas.addTo($('.stage'));
        return fbg.drawTools.show();
      } else {
        fbg.drawTools.hide();
        return fbg.addTrending();
      }
    } else {
      return convertAllImages(document.body);
    }
  };

  trackChanges = function() {
    var domCoolTest;
    domCoolTest = new fbg.DomCoolTest(fbg.onPageLoad, 300);
    $(document).on("DOMSubtreeModified", domCoolTest.warm);
    return $(window).on("onhashchange", domCoolTest.warm);
  };

  convertAllImages = function(base) {
    var addGraffiti;
    addGraffiti = function() {
      var id, img, url;
      id = fbg.urlParser.id(this.src);
      img = $(this);
      if (id == null) {
        return;
      }
      id = id[1];
      url = fbg.cache.idToUrl(id);
      if (url === null) {
        return;
      }
      return new fbg.FbgImg(img, id, url);
    };
    fbg.get.profileAndCover().each(addGraffiti);
    return setTimeout((function() {
      return $(base).find('img').not('.hasGraffiti').not('.spotlight').each(addGraffiti);
    }), 100);
  };

  $(function() {
    fbg.mouse = new EventEmitter();
    fbg.drawTools = new fbg.DrawTools();
    $(window).resize(function() {
      var _ref;
      return (_ref = fbg.canvas) != null ? _ref.resize() : void 0;
    });
    fbg.addTrending();
    fbg.createNotif();
    fbg.mouse.addListener('mousemove', (function(_this) {
      return function(options) {
        var _ref;
        if (fbg.drawing && options.onCanvas && options.dragging) {
          return (_ref = fbg.canvas) != null ? _ref.draw(options) : void 0;
        }
      };
    })(this));
    return fbg.mouse.addListener('mousedown', (function(_this) {
      return function(options) {
        var _ref;
        if (fbg.drawing && options.onCanvas) {
          return (_ref = fbg.canvas) != null ? _ref.saveState() : void 0;
        }
      };
    })(this));
  });

  fbg.cache = new fbg.ImageCache();

  fbg.currentPage = location.href;

  fbg.onPageLoad();

  trackChanges();

}).call(this);
