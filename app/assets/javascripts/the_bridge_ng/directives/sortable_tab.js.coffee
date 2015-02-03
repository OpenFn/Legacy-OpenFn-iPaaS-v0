@the_bridge.directive 'sortableTab', ['$timeout', '$document',($timeout, $document) ->
  link: (scope, element, attrs, controller) ->

    scope.dropFunction = scope.$eval(attrs["sortableTab"]) if attrs["sortableTab"]

    tabs = []

    wrap = (fn) ->
      (e) ->
        scope.$apply () ->
          fn(e)

    move = (fromIndex, toIndex) ->
      # http://stackoverflow.com/a/7180095/1319998
      tabs.splice(toIndex, 0, tabs.splice(fromIndex, 1)[0])

      # Call the function after moving
      scope.dropFunction() if scope.dropFunction

    # Attempt to integrate with ngRepeat
    # https://github.com/angular/angular.js/blob/master/src/ng/directive/ngRepeat.js#L211
    match = attrs.ngRepeat.match(/^\s*([\s\S]+?)\s+in\s+([\s\S]+?)(?:\s+track\s+by\s+([\s\S]+?))?\s*$/)

    scope.$watch match[2], (newTabs) ->
      tabs = newTabs

    index = scope.$index
    scope.$watch '$index', (newIndex) ->
      index = newIndex

    attrs.$set('draggable', true)

    # Wrapped in $apply so Angular reacts to changes
    wrappedListeners = {
      # On item being dragged
      dragstart: (e) ->
        e = e.originalEvent
        e.dataTransfer.effectAllowed = 'move'
        e.dataTransfer.dropEffect = 'move'
        e.dataTransfer.setData('application/json', index)
        element.addClass('dragging')

      dragend: (e) ->
        e = e.originalEvent

        #e.stopPropagation();
        element.removeClass('dragging')

      # On item being dragged over / dropped onto
      dragenter: (e) ->
        e = e.originalEvent

      dragleave: (e) ->
        e = e.originalEvent
        element.removeClass('hover');

      drop: (e) ->
        e = e.originalEvent
        e.preventDefault()
        e.stopPropagation()
        sourceIndex = e.dataTransfer.getData('application/json')
        move(sourceIndex, index)
        element.removeClass('hover')
    }

    # For performance purposes, do not
    # call $apply for these
    unwrappedListeners = {
      dragover: (e) ->
        e = e.originalEvent
        e.preventDefault()
        element.addClass('hover')

      # Use .hover instead of :hover. :hover doesn't play well with
      # moving DOM from under mouse when hovered
      mouseenter: () ->
        element.addClass('hover')

      mouseleave: () ->
        element.removeClass('hover')

    }

    angular.forEach(wrappedListeners, (listener, event) ->
      element.on(event, wrap(listener))
    )

    angular.forEach(unwrappedListeners, (listener, event) ->
      element.on(event, listener)
    )
]
