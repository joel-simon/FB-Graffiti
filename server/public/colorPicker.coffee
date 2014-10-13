# window.fbGraffiti.colorPicker = () ->
#   colors = ['#FF0000','#FF9900','#FFFF00','#009933','#00CCFF','#0000FF','#660066', '#FF00FF', '#FFF', '#808080','#000']
#   sizes = [2,8,14,20]

#   elemDiv = document.createElement 'div'
#   numCols = 2
#   width = 24
#   height = colors.length * 21
#   top = 52
  
#   frame = document.createElement 'div'
#   document.body.appendChild(frame)
#   $(frame).click (e) -> e.stopPropagation()

#   colorDiv = null
#   for i in [1..colors.length]
#     colorDiv = document.createElement('div')
#     colorDiv.className = colorDiv.className + ' colorPicker'
#     colorDiv.style.cssText = "opacity:1.0;position:fixed;width:16px;height:16px;
#       z-index:900;top:#{(i*24)+top}px;left:-40px;hover:{color:red};
#       background:#{colors[i]}"
#     $( colorDiv ).mouseover () ->
#       this.style.border = '2px solid #3b579d'
#     $( colorDiv ).mouseout () ->
#       this.style.border= 'none' if this != selected
#     $( colorDiv ).click (e) ->
#         e.preventDefault()
#         e.stopPropagation()
#         if (selected && selected != this)
#           selected.style.border= 'none'
#         selected = this
#         $('#container').css("background-color", this.style['background-color'])
#     document.body.appendChild(colorDiv)

#   selected = colorDiv
#   colorDiv.style.border= '2px solid #3b579d'


  
#   y = ((i+1)*24)+top
#   current = null
  
#   for s in sizes
#     s2 = s/2
#     clickDiv = document.createElement('div')
#     circleDiv = document.createElement('div')
#     clickDiv.className = clickDiv.className + ' radiusSelector'
#     clickDiv.id = 'size:'+s
#     circleDiv.style.cssText = "position:relativebackground:blackwidth:"+s+"pxheight:"+s+"pxborder-radius:"+s/2+"pxleft:"+(15-s2)+"pxtop:"+(12-s2)+"px"
#     clickDiv.style.cssText+= "border-style:solidborder-width:1pxwidth:30px height: "+(24)+"pxposition:fixed left: "+(-45)+"px top:"+y+"px"
#     clickDiv.appendChild(circleDiv)
#     frame.appendChild(clickDiv)

#     if s == 8
#       clickDiv.style.border="1px solid #3b579d"
#       $(clickDiv).css('box-shadow',"0 0 20px #3b579d")
#       current = clickDiv
#     ((div, _s) ->
#       $(div).click () ->
#         if current?
#           current.style.border = "1px solid black"
#           $(current).css('box-shadow',"none")
#         div.style.border="1px solid #3b579d"
#         $(div).css('box-shadow',"0 0 20px #3b579d")
#         current = div
#         console.log('size: '+_s)
#         strokeWidth = _s
#     )(clickDiv, s)
#     y += 24
#   frame.style.cssText = 'position:fixedwidth:'+2*width+'pxheight:'+(y-52)+'pxtop:'+52+'pxleft:0z-index:800background:rgba(255,0,0,0)'