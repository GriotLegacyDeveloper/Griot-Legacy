var express = require('express');
const { check } = require('express-validator');
var router = express.Router();
var login = require('../middleware/loginCheck');
var messagesApi = require('../app/controllers/messages-controller')

router.get('/customerMessages', login.afterLogin, login.accessControl, messagesApi.messagesList)
router.get('/fullMessage', login.afterLogin, login.accessControl, messagesApi.viewFullMessage)

module.exports = router;