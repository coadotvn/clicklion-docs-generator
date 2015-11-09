express = require 'express'
utils = require '../utilities'
db = require '../db'
Page = db.Page
Index = db.Index

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
    pages = []
    for page in docs
      do () ->
        lexer = new marked.Lexer()
        tokens = lexer.lex page.body
        sections = []
        section = null
        for token in tokens
          if token.type is 'heading' and token.depth is 1
            if section isnt null
              sections.push title: section.title, slug: utils.slug(section.title), articles: section.articles
              section = null
            section = title: token.text, slug: utils.slug(token.text), articles: []
          if token.type is 'heading' and token.depth is 2
            section.articles.push slug: utils.slug(token.text), title: token.text
        sections.push section
        page = _id: utils.slug(page.title), title: page.title, description: page.description, slug: utils.slug(page.title), sections: JSON.parse(JSON.stringify(sections))
        pages.push page
        null
    Index.remove {}, { multi: true }, (err, numRemoved) ->
      Index.insert pages
    res.json pages
    null

module.exports = router