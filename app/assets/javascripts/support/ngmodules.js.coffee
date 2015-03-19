do ->
  orig = angular.module
  angular.modules = []

  angular.module = ->
    args = Array::slice.call(arguments)
    if arguments.length > 1
      angular.modules.push arguments[0]
    orig.apply null, args

  return
