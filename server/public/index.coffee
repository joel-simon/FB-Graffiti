fs = require 'fs'
CoffeeScript = require 'coffee-script'
async = require 'async'

get = (cb) ->
  jsFiles = []
  fs.readdir __dirname, (err,files) ->
    return cb err if err?
    files = files.filter (f) ->
      f != 'index.coffee' and f.match(/.+\.(coffee|js)/g)?

    async.mapSeries files, loadFile, (err, files) ->
      return cb err if err?
      cb null, files.join ''

loadFile = (file, cb) ->
  fs.readFile "#{__dirname}/#{file}",'utf-8', (err, code) ->
    return cb err if err?
    try
      if file.match(/.+\.coffee/g)?
        cb null, CoffeeScript.compile code
      else
        cb null, code
    catch e
      cb "#{file}: #{e}"

module.exports.get = get