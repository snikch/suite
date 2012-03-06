document.onready = ->
	document.getElementById('coffee').innerHTML = message()
message = ->
	"<h2>Hey. This content was put here by JavaScript.</h2><p>You should check out <code>assets/javascripts/core.js.coffee</code>. That's the file that forced me to come into existence on your page.</p><p>If you want to know how that was loaded, check your <code>application.js</code>, and see how it includes 'core'. It's all thanks to <a href='https://github.com/sstephenson/sprockets'>Sprockets</a>.</p>"
