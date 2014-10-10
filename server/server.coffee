express = require 'express'
requestHandlers = require './requestHandlers'
port = process.env.PORT || 3000
app = express()
bodyParser = require 'body-parser'

app.use bodyParser limit: '50mb'
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use (req, res, next) ->
  res.setHeader 'Access-Control-Allow-Origin', 'chrome-extension://bpjglliobkbeopoiohankoknaonngkkj'
  res.setHeader 'Access-Control-Allow-Methods', 'GET, POST'
  res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type'
  res.setHeader 'Access-Control-Allow-Credentials', true
  next()

app.get '/share/:src', requestHandlers.shareSrc
app.post '/setImage', requestHandlers.setImage
app.post '/shareImage', requestHandlers.shareImage
app.get '/getSource.js', requestHandlers.getSource

app.listen port
console.log "Server started on port:#{port}"