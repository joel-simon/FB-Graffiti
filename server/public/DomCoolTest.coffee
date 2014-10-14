class DomCoolTest
  constructor: (@onCool, @t) ->
    @timer = null
  
  warm : () =>
    # console.log 'warming', @timer, @t
    if @timer?
      # console.log 'cleari'
      clearTimeout @timer
      @timer = null
    @timer = setTimeout (()=>
      @timer = null
      @onCool()   
    ), @t
  
  isWarm : () -> @timer?

window.fbg ?= {}
window.fbg.DomCoolTest = DomCoolTest