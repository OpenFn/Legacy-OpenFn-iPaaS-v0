@the_bridge.directive 'accordionsToggle', [ ->
  {
    link: (scope, element, attrs) ->
      element.click ->
        $('.accordion-container').slideToggle 'fast'
  }
 ]
