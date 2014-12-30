AWS = require 'aws-sdk'
AWS.config.loadFromPath __dirname+'/config.json'
s3 = new AWS.S3()

id = process.argv[2]

require('./public/').get (err, src) ->
  return console.log err if err
  params =
    Bucket: 'facebookGraffiti'
    Key: id+'.png'
  s3.deleteObject params, (err) ->
    console.log err or 'Success'