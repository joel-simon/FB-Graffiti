AWS = require 'aws-sdk'
AWS.config.loadFromPath __dirname+'/../config.json'
s3 = new AWS.S3()

module.exports = 
  getImage : ({bucket, path}, callback) ->
    params =
      Bucket: bucket
      Key: path
    s3.getObject params, callback

  putImage : ({ bucket, path, img }, callback) ->
    # return callback 'no img given ' if not img?
    # return callback 'no bucket given ' if not bucket?
    # return callback 'no path given ' if not path?
    console.log 'putImage', bucket, path, img
    params =
      Bucket: bucket
      Key: path
      ACL: 'public-read'
      Body: img
      ContentType: 'image/png'
    s3.putObject params, callback

  copyImage : ({ path, toBucket, fromBucket }, callback) ->
    params =
      Bucket: toBucket
      Key:    path
      ACL:    'public-read'
      ContentType: 'image/png'
      CopySource: "#{fromBucket}/#{path}"
    s3.copyObject params, callback