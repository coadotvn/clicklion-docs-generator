express = require 'express'
utils = require '../utilities'
db = require '../db'
Index = db.Index
Page = db.Page

# markdown
marked = require 'marked'
renderer = new marked.Renderer()
renderer.heading = (text, level) ->
  id = utils.slug text
  switch level
    when 1
      return "<section id=\"#{id}\"><h1 class=\"title\">#{text}</h1></section>"
    when 2
      return "<article id=\"#{id}\"><h2 class=\"title\">#{text}</h2></article>"
    else
      return "<h#{level}>#{text}</h#{level}>"

router = express.Router()

router.get '/', (req, res) ->
  Page.find {}, (err, docs) ->
    res.render 'pages/index', err: err, docs: docs

router.get '/new', (req, res) ->
  res.render 'pages/new'

router.get '/edit/:slug.html', (req, res) ->
  slug = req.params.slug
  Page.findOne { slug: slug }, (err, doc) ->
    unless err?
      if doc?
        res.render 'pages/edit',
          doc: doc
          title: doc.title
          description: doc.description
          body: if doc.body? then marked(doc.body, { renderer: renderer }) else ''
      else
        res.sendStatus 404
    else
      res.sendStatus 404

  res.render 'pages/edit'

router.post '/new', (req, res) ->
  Page.insert req.body, (err, doc) ->
    res.redirect '/' + doc.slug + '.html'

router.post '/edit/:slug.html', (req, res) ->
  slug = req.params.slug
  Page.update { slug: slug }, req.body
  res.redirect '/'

view = (req, res) ->
  slug = req.params.slug
  Index.find {}, (req, indexes) ->
    Page.findOne { slug: slug }, (err, doc) ->
      unless err?
        if doc?
          res.render 'pages/view',
            doc: doc
            title: doc.title
            description: doc.description
            indexes: indexes
            body: if doc.body? then marked(doc.body, { renderer: renderer }) else ''
        else
          res.sendStatus 404
      else
        res.sendStatus 404

router.get '/view/:slug.html', view
router.get '/:slug.html', view


module.exports = router