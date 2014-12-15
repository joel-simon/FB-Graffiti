fs = require 'fs'
CoffeeScript = require 'coffee-script'

get = (cb) ->
  jsFiles = []
  fs.readdir __dirname, (err,files) ->
    return cb err if err?
    files = files.filter (f) ->
      f != 'index.coffee' and f.match(/.+\.(coffee|js)/g)?
    c = files.length
    files.forEach (file) ->
      fs.readFile "#{__dirname}/#{file}",'utf-8', (err, code) ->
        return cb err if err?
        try
          code = if file.match(/.+\.coffee/g)? then CoffeeScript.compile code else code
        catch e
          return cb "#{file}: #{e}"
        
        jsFiles.push code
        if 0 is --c
          cb null, jsFiles.join ''

module.exports.get = get