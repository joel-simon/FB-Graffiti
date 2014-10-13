pg = require 'pg'
config = require '../config'
dbstring = config.POSTGRES_URL
console.log dbstring
pg.connect dbstring, (err, client, done) ->
  if not client
    throw 'No Connection to Postgresql'+err

rollback = (client, done) ->
  client.query 'ROLLBACK', (err) -> done err
  
String.prototype.insert = (index, string) ->
  if index > 0
    this.substring(0, index) + string + this.substring(index, this.length)
  else
    string + this

exports.query = (text, values, cb) ->
  if not cb?
    cb = values
    values = []

  if not typeof(text) is 'string'
    return cb 'Invalid db.query params. text:'+text
  if not Array.isArray(values)
    return cb 'Invalid db.query params. values:'+values
  if not typeof(cb) is 'function'
    return cb 'Invalid db.query params. cb:'+cb
  
  pg.connect dbstring, (err, client, done) ->
    client.query text, values, (err, result) ->
      done()
      if err
        err.text = text.insert(err.position-1, '->')
      if cb
        cb err, result
      else
        console.log 'Call to db.query withouth a callback, very bad!!'
        console.trace()
      
exports.transaction = (main, cb) ->
  pg.connect dbstring, (err, client, done) ->
    return cb err if err?
    client.query 'BEGIN', (err) ->
      process.nextTick () ->
        main (err, results) ->
          if err?
            rollback client, done
            cb err
          else
            client.query 'COMMIT', done
            cb null