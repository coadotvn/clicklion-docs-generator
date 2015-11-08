express = require 'express'
marked = require 'marked'
db = require '../db'
Page = db.Page

router = express.Router()

router.get '/', (req, res) ->
  Page.find {}, (err, docs) ->
    res.render 'pages/index', err: err, docs: docs

router.get '/new', (req, res) ->
  res.render 'pages/new'

router.post '/new', (req, res) ->
  Page.insert req.body, (err, doc) ->
    unless err?
      res.redirect '/pages/view/' + doc._id

router.get '/view/:_id', (req, res) ->
  _id = req.params._id
  Page.findOne { _id: _id }, (err, doc) ->
    res.render 'pages/view', err: err, doc: doc, marked: marked

module.exports = router