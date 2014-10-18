class DomCoolTest
  constructor: (@onCool, @t) ->
    @timer = null
  
  warm : () =>
    if @timer?
      clearTimeout @timer
      @timer = null
    @timer = setTimeout (()=>
      @timer = null
      @onCool()   
    ), @t
  
  isWarm : () -> @timer?

window.fbg ?= {}
window.fbg.DomCoolTest = DomCoolTest