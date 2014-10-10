require('fs').readdirSync(__dirname + '/').forEach (file) ->
  if file.match(/.+\.coffee/g)? and file != 'index.coffee'
    name = file.replace '.coffee', ''
    module.exports[name] = require "./#{file}"