db = require '../adapters/db'
moment = require 'moment'

module.exports = (req, res) ->
  q = """
    SELECT COUNT(distinct(id)) AS count
       , (extract('epoch' from post_time)::int / 3600) AS hour
       , AVG(time_taken)::int AS average
    FROM events
    group by hour
    order by hour desc
  """

  db.query q, [], (err, results) ->
    console.log err if err?
    return res.send 400 if err?
    s = ''
    results.rows.forEach (r) ->
      day = moment(r.hour * 3600 * 1000).format "YYYY MMMM Do ddd, hA"
      s += "#{day}   :   #{r.count}   :   #{r.average}<br>"
    res.send s