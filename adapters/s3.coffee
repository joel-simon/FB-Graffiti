AWS = require 'aws-sdk'
AWS.config.loadFromPath __dirname+'/../config.json'
AWS.config.update httpOptions: { proxy: 'http://localhost:4567' }
s3 = new AWS.S3()

module.exports = 
	getImage : ({bucket, path}, callback) ->
	  params =
	    Bucket: bucket
	    Key: path
	  s3.getObject params, callback

	putImage : ({ bucket, path, image }, callback) ->
	  params =
	    Bucket: bucket
	    Key: path
	    ACL: 'public-read'
	    Body: image
	    ContentType: 'image/png'
	  s3.putObject params, callback

	copyImage : ({ path, toBucket, fromBucket }, callback) ->
		params =
			Bucket: toBucket
			Key: 		path
			ACL: 		'public-read'
			ContentType: 'image/png'
			CopySource: "#{fromBucket}/#{path}"
		s3.copyObject params, callback