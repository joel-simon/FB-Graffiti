publicCode = require '../public'

module.exports = (req, res) ->
	res.set 'Content-Type', 'text/javascript'
	res.send publicCode()