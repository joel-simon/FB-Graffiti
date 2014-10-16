db = require('./adapters/db')
async = require('async')

initQuery = 'CREATE TABLE events (
  post_time timestamp with time zone NOT NULL DEFAULT now(),
  time_taken integer NOT NULL,
  width integer NOT NULL,
  height integer NOT NULL,
  type text NOT NULL,
  id text NOT NULL
)'

async.series [
  (cb) -> db.query "drop schema public cascade;create schema public", cb
  (cb) -> db.query initQuery, cb
], (err) ->
  if err
    console.log err
    process.exit 1
  else
    console.log 'Init Complete'
    process.exit 0