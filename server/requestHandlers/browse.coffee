db = require '../adapters/db'
module.exports = (req, res) ->
	q = 'select distinct(id), post_time, id, type from events order by post_time desc limit 50;'
	db.query q, [], (err, results) ->
		# console.log results.rows
	  res.render 'browse.jade', {imgList: results.rows}