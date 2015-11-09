Datastore = require 'nedb'
db =
  Page: new Datastore filename: './databases/pages', autoload: true
  Index: new Datastore filename: './databases/indexes', autoload: true

module.exports = db