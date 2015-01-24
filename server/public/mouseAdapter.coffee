prevX = 0
currX = 0
prevY = 0
currY = 0
dragging = null


document.addEventListener "mousemove", ((e) -> onMouse('move', e)), false
document.addEventListener "mousedown", ((e) -> onMouse('down', e)), false
document.addEventListener "mouseup",  ((e) -> onMouse('up',   e)), false
document.addEventListener "mouseout", ((e) -> onMouse('out',  e)), false

window.fbg ?= {}

onMouse = (eventType, e) ->
  return if !fbg.canvas
  onCanvas = e.target is fbg.canvas.canvas[0]

  if eventType == 'down'
    prevX = currX
    prevY = currY

    currX = e.offsetX
    currY = e.offsetY
    dragging = true

    options = { currX, currY, prevX, prevY, onCanvas }
    fbg.mouse.emitEvent 'mousedown', [options]

  if dragging && eventType == 'up' || dragging && eventType == "out"
    console.log 'emitEvent mouseup'
    fbg.mouse.emitEvent 'mouseup', [ { dragging } ]
    dragging = false

  if eventType == 'move'
    prevX = currX
    prevY = currY
    currX = e.offsetX
    currY = e.offsetY

    options = { currX, currY, prevX, prevY, onCanvas, dragging }
    fbg.mouse.emitEvent 'mousemove', [ options ]