var AWS = require('aws-sdk'); 
var fs = require('fs');
var sys = require('sys');
AWS.config.loadFromPath('./config.json');
var s3 = new AWS.S3();
var images = require ('images');
AWS.config.loadFromPath('./config.json');
var cluster = require('cluster');
var http = require('http');
var numCPUs = 1;//require('os').cpus().length;



if (cluster.isMaster) {
  for (var i = 0; i < numCPUs; i++) {
    cluster.fork();
  }
  cluster.on('exit', function(worker, code, signal) {
    console.log('worker ' + worker.process.pid + ' died');
  });
} else {
	var express = require('express');
	var app = express();
	var bodyParser = require('body-parser');
	app.use(bodyParser({limit: '50mb'}));

	app.set('views', __dirname + '/views');
	app.set('view engine', 'jade');

	var pg = require('pg'); 
	var pg_client = new pg.Client(process.env.db_string);

	pg_client.connect(function(err) {
	  if(err) {
	    return console.error('could not connect to postgres', err);
	  } else {
	  	console.log('Established a pg connection.');
	  }
	});

	app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', 'https://facebook.com');//
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
    res.setHeader('Access-Control-Allow-Credentials', true);
    next();
	});


	function getImage(path, cb) {
		var params = {
			Bucket: 'facebookGraffiti',
			Key: 		path
		};
		s3.getObject(params, cb);
	}

	app.get('/test', function(req,res) {
		res.send('Hello World');
	});

	app.get('/share/:src', function(req, res) {
		var src = req.params.src;
		res.render('share', { src:'https://s3.amazonaws.com/graffitiSnapshots/'+src});
		console.log('https://s3.amazonaws.com/graffitiSnapshots/'+src);
	});

	app.post('/setImage', function(req, res) {
		
		var path = req.body.path+'.png';
		var img = req.body.img;
		var imgUrl = req.body.imgUrl;
		var data = img.replace(/^data:image\/\w+;base64,/, "");
		var delta = images(new Buffer(data, 'base64'));
		var start = new Date().getTime();
		getImage(path, function(err, data) {

			var newImage;
			var width;
			var height;
			// this post has not been drawn on before.
			if (err) {
				// console.log('New image');
				width = delta.width();
				height = delta.height();
				newImage = (delta).encode("png");
			} else { // append the changes
				// console.log('Appending to old image');
				var oldImg = images(data.Body);
				var oldWidth = oldImg.width();
				var oldHeight = oldImg.height();
				var dWidth = delta.width();
				var dHeight = delta.height();
				width = oldWidth;
				height = oldHeight;
				if (dHeight > oldHeight && dWidth == oldWidth) { // need to englarge image.
					// console.log('Need to vertically increase old image');
					newImage = images(dWidth, dHeight).draw(oldImg,0,0).draw(delta,0,0).encode("png");
					height = dHeight;
				} else if (dHeight != oldHeight || dWidth != oldWidth) {
					// console.log('Need to scale new image');
					newImage = oldImg.draw(delta.size(oldWidth, oldHeight),0,0).encode("png");
				} else {
					newImage = oldImg.draw(delta,0,0).encode("png");
				}

			}
			var params = {
				Bucket: 'facebookGraffiti',
				Key: 		path,
				ACL: 		'public-read',
				Body: newImage,
				ContentType: 'image/png'
			}

			s3.putObject(params, function(err, data) {
			  if (err) {
				  console.log('Err putting:', err);
				  res.send(404);
			  } else {
			  	console.log(path);
			  	res.send(path);
			  	var end = new Date().getTime();
					var time = end - start;

					var query = "INSERT INTO events (time_taken, url, id, width, height) values ($1,$2,$3,$4,$5)";
					
				 // console.log(newImage.width(), newImage.height());
					pg_client.query(query, [time,imgUrl, path, width, height], function(err, result) {
						if (err) {
							console.log('ERR:'+err);
						}
					});
			  }
		  });
		});
	});

	app.post('/shareImage', function(req, res) {
		var path = req.body.path+'.png';
		var img = req.body.img;
		var imgUrl = req.body.imgUrl;
		var data = img.replace(/^data:image\/\w+;base64,/, "");
		var delta = images(new Buffer(data, 'base64'));
		var start = new Date().getTime();

		newImage = (delta).encode("png");	
		var params = {
			Bucket: 'graffitiSnapshots',
			Key: 		path,
			ACL: 		'public-read',
			Body: newImage,
			ContentType: 'image/png'
		}

		s3.putObject(params, function(err, data) {
		  if (err) {
			  console.log('Err putting:', err);
			  res.send(404);
		  } else {
		  	console.log(path);
		  	res.send(path);
		  	var end = new Date().getTime();
				var time = end - start;

				var query = "INSERT INTO events (time_taken, url, id, width, height) values ($1,$2,$3,$4,$5)";
				
			 // console.log(newImage.width(), newImage.height());
				// pg_client.query(query, [time,imgUrl, path, width, height], function(err, result) {
				// 	if (err) {
				// 		console.log('ERR:'+err);
				// 	}
				// });
		  }
	  });
	});
	function copy(id){
		var params = {
			Bucket: 'graffitiSnapshots',
			Key: 		id,
			ACL: 		'public-read',
			ContentType: 'image/png',
			CopySource: 'facebookGraffiti/'+id
		}
		s3.copyObject(params, function(err, data) {
		  if (err) console.log(err, err.stack);
		});
	}
	app.listen(3000);
	copy('-2255330727544526857.png')
}