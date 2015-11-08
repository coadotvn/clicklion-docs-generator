express = require 'express'
bodyParser = require 'body-parser'
app = express()

# engine
jade = require('jade').__express
app.engine 'jade', jade
app.set 'view engine', 'jade'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: true

# js
coffee = require 'coffee-middleware'
js = coffee
  src: __dirname + '/public'
  compress: true
app.use js

# css
stylus = require 'stylus'
nib = require 'nib'
css = stylus.middleware
  src: __dirname + '/public'
  compile: (str, path) ->
    return stylus(str)
      .set 'filename', path
      .set 'compress', true
      .set 'warn', true
      .use nib()
app.use css

# routes
app.use express.static(__dirname + '/public')
app.use require('./controllers')

# listen
app.listen 3000, () ->
  console.log 'http://localhost:3000'