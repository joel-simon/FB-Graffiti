db = require '../adapters/db'
moment = require 'moment'

module.exports = (req, res) ->
  pass = req.body.password
  if pass == process.env.PASSWORD
    renderReported req, res
  else
    res.send 401

renderReported = (req, res) ->
  q = "select * FROM 
        graffiti 
      WHERE
        graffiti.reported = true
      limit 25"
  db.query q, [], (err, results) ->
    console.log err if err
    if results.rows?.length
      results.rows.forEach (r) ->
        r.time = moment(r.time).fromNow()
    res.render 'browseReported.jade', { imgList: results.rows }