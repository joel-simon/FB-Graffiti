AWS = require 'aws-sdk'
AWS.config.loadFromPath __dirname+'/config.json'
s3 = new AWS.S3()

isDev = process.argv[2] is '-d'

require('./public/').get (err, src) ->
  return console.log err if err
  params =
    Bucket: 'fbgsource'
    Key: if isDev then 'sourceDev.js' else 'source.js'
    ACL: 'public-read'
    Body: src
    ContentType: 'text/javascript'
  s3.putObject params, (err) ->
    console.log err or 'Success'