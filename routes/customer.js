var express = require('express');
const { check } = require('express-validator');
var router = express.Router();
var customerApi = require('../app/controllers/customer-controller');
var login = require('../middleware/loginCheck');
 

//Customer
router.get('/customerList',login.afterLogin,login.accessControl,customerApi.customerList);
router.get('/customerStatus',login.afterLogin,login.accessControl,customerApi.customerStatus);
router.get('/customerViewPost',login.afterLogin,login.accessControl,customerApi.customerPostView);
router.get('/getPost',login.afterLogin,login.accessControl,customerApi.getPostDetails);
router.get('/editCustomerPost',login.afterLogin,login.accessControl, customerApi.getEditCustomerPost);
router.post('/makeEditCustomerPost',login.afterLogin,login.accessControl, customerApi.makeEdits);
router.get('/customerDelete',login.afterLogin,login.accessControl, customerApi.customerDelete);
router.get('/blockPost',login.afterLogin,login.accessControl, customerApi.postBlock);
router.get('/addNewCustomer', login.afterLogin, login.accessControl, customerApi.getAddCustomer);
router.post('/createCustomer', login.afterLogin, login.accessControl, customerApi.addNewCustomer);
router.get('/trackStorage', login.afterLogin, login.accessControl, customerApi.trackStorage)

module.exports = router;