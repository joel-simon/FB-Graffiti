db = require '../adapters/db'
moment = require 'moment'
tz = require 'moment-timezone'
module.exports = (req, res) ->
  q = """
    SELECT COUNT(*) AS count
       , (extract('epoch' from post_time)::int / (3600*24)) AS day
       , AVG(time_taken)::int AS average
      FROM events
      
      group by day
      order by day desc
  """
  #, FROM (select * from events where date(post_time) = date(now())) as bar
  #WHERE type = 'new'
  db.query q, [], (err, results) ->
    console.log err if err?
    return res.send 400 if err?

    html = """
      <table style="width:100%">
      <tr>
        <th>Date</th>
        <th>Avg time</th>   
        <th>Num events</th>
      </tr>
    """
    results.rows.forEach (r) ->
      day = moment(r.day * 24 * 3600 * 1000).tz("Europe/Paris").format "YYYY MMMM Do ddd"
      html += "<tr> <td>#{day}</td> <td>#{r.average}</td> <td>#{r.count}</td> </tr>"
    html += '</table>'
    res.send html