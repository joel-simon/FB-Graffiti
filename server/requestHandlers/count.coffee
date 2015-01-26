db = require '../adapters/db'

module.exports = (req, res) ->
  q = """
      SELECT 
        (SELECT COUNT(*) from events) as drawings,
        (SELECT COUNT(*) FROM graffiti) as images
      """

  db.query q, [], (err, results) ->
    console.log err if err?
    return res.send 400 if err?
    res.json results.rows