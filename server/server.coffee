https = require 'https'
express = require 'express'
app = express()
fs = require 'fs'
requestHandlers = require './requestHandlers'
bodyParser = require 'body-parser'

app.use bodyParser limit: '20mb'
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/client')

app.use (req, res, next) ->
  res.header "Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"
  res.setHeader 'Access-Control-Allow-Origin', 'chrome-extension://kghggnemnbblgfdijmkollcjacjdapmp'
  res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
  res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type'
  res.setHeader 'Access-Control-Allow-Credentials', true
  next()

app.post '/setImage', requestHandlers.setImage
app.get '/browse', requestHandlers.browse
app.get '/', (req, res) -> res.send 200, 'Hello'

options =
  key: fs.readFileSync './certs/fbg.key', 'utf8'
  cert: fs.readFileSync './certs/fbg.pem', 'utf8'

server = https.createServer(options, app).listen 443
server.listen 443, () ->
  console.log "SSl server started on port:443"
