Datastore = require 'nedb'
db =
  Page: new Datastore filename: './databases/pages', autoload: true

module.exports = db