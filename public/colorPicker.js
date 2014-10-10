var selected;
(function(){
  var colors = ['#FF0000','#FF9900','#FFFF00','#009933','#00CCFF','#0000FF','#660066', '#FF00FF', '#FFF', '#808080','#000']
  var elemDiv = document.createElement('div');
  var numCols = 2;
  var width = 24;
  var height = colors.length * 21;
  var top = 52;
  
  var frame = document.createElement('div');
  document.body.appendChild(frame);
  $(frame).click(function(e){e.stopPropagation()});

  var colorDiv;
  for (var i = 0; i < colors.length; i++) {
    colorDiv = document.createElement('div');
    colorDiv.className = colorDiv.className + ' colorPicker';
    colorDiv.style.cssText = 'opacity:1.0;position:fixed;width:16px;height:16px;'+
                              'z-index:900;'+
                              'top:'+((i*24)+top)+'px;'+
                              'left:-40px;'+
                              // 'border:1px solid black;cursor:pointer;'+
                              'hover:{color:red;};'+
                              'background:'+colors[i]+';';
    
    $( colorDiv )
      .mouseover(function() {
        this.style.border="2px solid #3b579d";
      })
      .mouseout(function() {
        if(this != selected) {
          this.style.border= 'none'//"1px solid #000";
        } 
      })
      .click(function(e) {
        // return console.log(this);
        e.preventDefault();
        e.stopPropagation();
        if (selected && selected != this) {
          selected.style.border= 'none'
        }
        selected = this;
        $('#container').css("background-color", this.style['background-color'])
      });
      document.body.appendChild(colorDiv);
    }
    selected = colorDiv;
    colorDiv.style.border="2px solid #3b579d";


  var sizes = [2,8,14,20];
  var y = (((i+1)*24)+top);
  var current;
  for (var j = 0; j < sizes.length; j++) {
    var s = sizes[j];
    var s2 = s/2;
    var clickDiv = document.createElement('div');
    var circleDiv = document.createElement('div');
    clickDiv.className = clickDiv.className + ' radiusSelector';
    clickDiv.id = 'size:'+s
    circleDiv.style.cssText = "position:relative;background:black;width:"+s+"px;height:"+s+"px;border-radius:"+s/2+"px;left:"+(15-s2)+"px;top:"+(12-s2)+"px";
    clickDiv.style.cssText+= "border-style:solid;border-width:1px;width:30px; height: "+(24)+"px;position:fixed; left: "+(-45)+"px; top:"+y+"px;";
    clickDiv.appendChild(circleDiv);
    frame.appendChild(clickDiv);

    if (s == 8){
      clickDiv.style.border="1px solid #3b579d";
      $(clickDiv).css('box-shadow',"0 0 20px #3b579d");
      current = clickDiv;
    }
    // console.log(circleDiv);
    (function (div, _s) {
      $(div).click(function() {
        if(current) {
          current.style.border="1px solid black";
          $(current).css('box-shadow',"none")
        }
        div.style.border="1px solid #3b579d";
        $(div).css('box-shadow',"0 0 20px #3b579d")
        current = div;
        console.log('size: '+_s);
        strokeWidth = _s;
      });
    })(clickDiv, s);
    y += 24;
  }
  // $( "#size:"+8 ).trigger( "click" );

  frame.style.cssText = 'position:fixed;width:'+2*width+'px;height:'+(y-52)+'px;top:'+52+'px;left:0;z-index:800;background:rgba(255,0,0,0);';

})();