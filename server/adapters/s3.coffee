AWS = require 'aws-sdk'
AWS.config.loadFromPath __dirname+'/../config.json'
s3 = new AWS.S3()

module.exports = 
  getImage: ({bucket, path}, callback) ->
    params =
      Bucket: bucket
      Key: path
    s3.getObject params, callback

  putImage: ({ bucket, path, img }, callback) ->
    # console.log 'putImage', bucket, path
    params =
      Bucket: bucket
      Key: path
      ACL: 'public-read'
      Body: img
      ContentType: 'image/png'
    s3.putObject params, callback

  copyImage: ({ path, toBucket, fromBucket }, callback) ->
    params =
      Bucket: toBucket
      Key:    path
      ACL:    'public-read'
      ContentType: 'image/png'
      CopySource: "#{fromBucket}/#{path}"
    s3.copyObject params, callback

  deleteImg: (id, cb) ->
    console.log 'deleting', id
    params =
      Bucket: 'facebookGraffiti'
      Key: id+'.png'
    s3.deleteObject params, cb
