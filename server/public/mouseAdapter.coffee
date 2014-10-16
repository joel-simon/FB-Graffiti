prevX = 0
currX = 0
prevY = 0
currY = 0
flag = null
dot_flag = null

document.addEventListener "mousemove", ((e) -> onMouse('move', e)), false
document.addEventListener "mousedown", ((e) -> onMouse('down', e)), false
document.addEventListener "mouseup",  ((e) -> onMouse('up',   e)), false
document.addEventListener "mouseout", ((e) -> onMouse('out',  e)), false

onMouse = (eventType, e) ->
  return if !fbg.canvas
  return if e.target != fbg.canvas.canvas[0]
  if eventType == 'down'
    prevX = currX
    prevY = currY

    currX = e.offsetX
    currY = e.offsetY
    flag = true;

  if flag && eventType == 'up' || eventType == "out"
      flag = false

  if eventType == 'move'
    if (flag)
      prevX = currX
      prevY = currY
      currX = e.offsetX
      currY = e.offsetY
      fbg.canvas?.draw { prevX, prevY, currX, currY }