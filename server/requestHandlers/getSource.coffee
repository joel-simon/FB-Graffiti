publicCode = require '../public'

publicCode.get (err, code) ->
  console.log err if err?

module.exports = (req, res) ->
  res.set 'Content-Type', 'text/javascript'
  publicCode.get (err, code) ->
    if err
      console.log err
      res.send 400
    else
      res.send 200, code