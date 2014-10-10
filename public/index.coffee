fs = require 'fs'
CoffeeScript = require 'coffee-script'
jsFiles = []

fs.readdir __dirname, (err,files)->
  throw err if err?
  c = files.length - 1
  files.forEach (file) ->
    if file != 'index.coffee'
      fs.readFile "#{__dirname}/#{file}",'utf-8', (err, code) ->
        throw err if err?
        code = if file.match(/.+\.coffee/g)? then CoffeeScript.compile code else code
        jsFiles.push code
        if 0 is --c
          done()

done = () ->
  jsFiles = jsFiles.join ''

module.exports = () ->
  jsFiles