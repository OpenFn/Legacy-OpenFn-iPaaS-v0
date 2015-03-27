@the_bridge.directive 'facebookPlugin', ->
	templateUrl: 'the_bridge_templates/facebook_plugin.html'
	controller: ->
		((d, s, id) ->
		  js = undefined
		  fjs = d.getElementsByTagName(s)[0]
		  if d.getElementById(id)
		    return
		  js = d.createElement(s)
		  js.id = id
		  js.src = '//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.3'
		  fjs.parentNode.insertBefore js, fjs
		  return
		) document, 'script', 'facebook-jssdk'

