var AWS = require('aws-sdk'); 
var fs = require('fs');
var sys = require('sys');
AWS.config.loadFromPath('./config.json');
var s3 = new AWS.S3();
var images = require ('images');
AWS.config.loadFromPath('./config.json');
var cluster = require('cluster');
var http = require('http');
var numCPUs = require('os').cpus().length;

if (cluster.isMaster) {
  for (var i = 0; i < numCPUs; i++) {
    cluster.fork();
  }
  cluster.on('exit', function(worker, code, signal) {
    console.log('worker ' + worker.process.pid + ' died');
  });
} else {
	server();
	var express = require('express');
	var app = express();
	var bodyParser = require('body-parser');
	app.use(bodyParser({limit: '50mb'})); //

	app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', 'https://facebook.com');
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

	app.post('/setImage', function(req, res) {
		
		var path = req.body.path+'.png';
		var img = req.body.img;
		var data = img.replace(/^data:image\/\w+;base64,/, "");
		var delta = images(new Buffer(data, 'base64'));
		var start = new Date().getTime();
		res.send('hello world');
		getImage(path, function(err, data) {

			var newImage;
			// this post has not been drawn on before.
			if (err) {
				console.log('New image');
				newImage = (delta).encode("png");

			} else { // append the changes
				console.log('Appending to old image');
				var oldImg = images(data.Body);
				var oldWidth = oldImg.width();
				var oldheight = oldImg.height();
				var dWidth = delta.width();
				var dHeight = delta.height();
				
				if (dHeight > oldheight && dWidth == oldWidth) { // need to englarge image.
					console.log('Need to vertically increase old image');
					newImage = images(dWidth, dHeight).draw(oldImg,0,0).draw(delta,0,0).encode("png");
				} else if (dHeight > oldheight && dWidth > oldWidth) {
					console.log('Need to scale new image');
					newImage = oldImg.draw(delta.size(oldWidth, oldheight),0,0).encode("png");
				} else {
					newImage = oldImg.draw(delta,0,0).encode("png");
				}

			}
			var params = {
				Bucket: 'facebookGraffiti',
				Key: 		path,
				Body: 	newImage,
				ACL: 		'public-read'
			};
			s3.putObject(params, function(err, data) {
			  if (err) {
				  console.log(err);
			  } else {
			  	var end = new Date().getTime();
					var time = end - start;
					var date = new Date().toLocaleString("en-US", {timeZone: "America/New_York"});
				  date = date.substring(0,date.search("GMT")-1);
			  	console.log("Successfully uploaded \n\t URL:", path, "\n\tIn: ", time);  
			  	console.log('\t'+date);
			  }
		  });
		});
	});
	app.listen(3000);
}