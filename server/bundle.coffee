AWS = require 'aws-sdk'
fs = require 'fs'

isDev = process.argv[2] is '-d'
require('./public/').get (err, src) ->
  return console.log err if err
  fs.writeFile "/Users/joelsimon/Projects/FB Graffiti/main/ChromeExtension/src.js", src, (err) ->
    if err
      console.log err
    else
      console.log "The file was saved!"