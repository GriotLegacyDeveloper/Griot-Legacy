var express = require('express');
const { check } = require('express-validator');
var router = express.Router();
var contentApi = require('../app/controllers/content-controller');
// var settings = require('../middleware/settings');
var login = require('../middleware/loginCheck');

//Content
router.get('/contentList', login.afterLogin, login.accessControl, contentApi.contentList);
router.get('/contentEdit', login.afterLogin, login.accessControl, contentApi.contentEdit);
router.post('/contentEditPost', login.afterLogin, contentApi.contentEditPost);

router.get('/advertisements', login.afterLogin, login.accessControl, contentApi.adList);
router.get('/advertisementAdd', login.afterLogin, login.accessControl, contentApi.getAddAdvertisement);
router.get('/editAdvertisement', login.afterLogin, login.accessControl, contentApi.getEditAd);
router.post('/advertisementAdd', login.afterLogin, login.accessControl, contentApi.addAdvertisement);
router.post('/editAdvertisement', login.afterLogin, login.accessControl, contentApi.editAd);
router.get('/deleteAd', login.afterLogin, login.accessControl, contentApi.deleteAd);
router.get('/adStatus', login.afterLogin, login.accessControl, contentApi.adStatus);



module.exports = router;