var express = require('express');
const { check } = require('express-validator');
var router = express.Router();
var login = require('../middleware/loginCheck');
var dashboardApi = require('../app/controllers/dashboard-controller')

router.get('/dashboard', login.afterLogin, login.accessControl, dashboardApi.usercount)
// router.get('/fullMessage', login.afterLogin, login.accessControl, messagesApi.viewFullMessage)

module.exports = router;