requestHandlers = require './requestHandlers'

https = require 'https'
express = require 'express'
fs = require 'fs'
port = 8080

app = express()

bodyParser = require 'body-parser'
app.use bodyParser limit: '20mb'
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*");
  # res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  # res.setHeader 'Access-Control-Allow-Origin', 'chrome-extension://bpjglliobkbeopoiohankoknaonngkkj'
  # res.setHeader 'Access-Control-Allow-Origin', 'http://localhost'
  # res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
  # res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type'
  # res.setHeader 'Access-Control-Allow-Credentials', true
  next()

app.get '/share/:src', requestHandlers.shareSrc
app.get '/getSource.js', requestHandlers.getSource
app.post '/setImage', requestHandlers.setImage
app.post '/shareImage', requestHandlers.shareImage
app.get '/', (req, res) -> 
  res.send 200, 'Hello'

options =
  key : fs.readFileSync './certs/fbg-key.pem', 'utf8'
  cert : fs.readFileSync './certs/fbg-cert.pem', 'utf8'

# server = https.createServer(options, app).listen(443)
# server.listen port, () ->
#   console.log "Server started on port:#{port}"

server = app.listen port, () ->
  host = server.address().address
  port = server.address().port
  console.log('Example app listening at http://%s:%s', host, port)