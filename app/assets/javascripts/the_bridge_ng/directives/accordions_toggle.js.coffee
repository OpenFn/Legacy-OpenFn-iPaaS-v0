@the_bridge.directive 'accordionsToggle', [ ->
  {
    link: (scope, element, attrs) ->
      element.click ->
        $('.accordion-container').slideToggle 'fast'
  }
 ]

@the_bridge.directive 'accordionHighlight', [ ->
  {
    link: (scope, element, attrs) ->
      element.click ->
        element.css('background', '#5b6a70')
        if element.parent().parent().parent().next().hasClass('in')
          element.css({'background': '#cfd0cc', 'color': '#333'})
        else
          element.css({'background': '#5b6a70', 'color': 'white'})
  }
 ]
