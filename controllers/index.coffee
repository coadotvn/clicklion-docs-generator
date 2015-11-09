express = require 'express'
router = express.Router()

router.use '/pages', require './pages'
router.use '/indexes', require './indexes'

router.use '/', require './pages'

module.exports = router