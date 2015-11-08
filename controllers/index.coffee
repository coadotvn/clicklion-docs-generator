express = require 'express'
router = express.Router()

router.use '/pages', require './pages'

router.get '/', (req, res) ->
  res.sendStatus 200

module.exports = router