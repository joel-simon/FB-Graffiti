class fbg.DrawTools
  constructor: () ->
    $("<input type='text'/>")
      .attr({id:'custom'})
      .prependTo $(document.body)
      .spectrum({ 
        color: "#f00"
        allowEmpty: true
       })
    @hide()

  hide: () ->
    $('.sp-replacer').hide()

  show: () ->
    $('.sp-replacer').prependTo $('.stage')
    $('.sp-replacer').show()

  color: () ->
    $('.sp-preview-inner').css('background-color')