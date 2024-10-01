var express = require('express');
var router = express.Router();
var login = require('../middleware/loginCheck');
var appUsageApi = require('../app/controllers/appUsage')

router.get('/appUsageShow', appUsageApi.displayAll)

module.exports = router;