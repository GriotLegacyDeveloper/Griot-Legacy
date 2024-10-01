'use strict';
var express = require('express');
const config = require('../config');
const customerValidator = require('../middlewares/validators/customer/customer-validator');
const tribeModel = require('../models/user/tribe-model');

const jwtTokenValidator = require('../middlewares/jwt-validation-middlewares');

var customerApi = express.Router();
customerApi.use(express.json());
customerApi.use(express.urlencoded({extended: false}));



customerApi.post('/createTribe', customerValidator.createTribe, function(req, res) {
    tribeModel.createTribe(req, function(result) {
        res.status(200).send(result);
    })
});


customerApi.post('/tribeList', customerValidator.home, function(req, res) {
    tribeModel.tribeList(req, function(result) {
        res.status(200).send(result);
    })
});

customerApi.post('/addInnerCircleMember',jwtTokenValidator.validateToken, customerValidator.addInnerCircleMember, function(req, res) {
    tribeModel.addInnerCircleMember(req, function(result) {
        res.status(200).send(result);
    })
});

customerApi.post('/innerCircleList',jwtTokenValidator.validateToken, customerValidator.home, function(req, res) {
    tribeModel.innerCircleList(req, function(result) {
        res.status(200).send(result);
    })
});

customerApi.post('/blockUser',jwtTokenValidator.validateToken, customerValidator.blockUser, function(req, res) {
    tribeModel.blockUser(req, function(result) {
        res.status(200).send(result);
    })
});

customerApi.post('/unblockUser',jwtTokenValidator.validateToken, customerValidator.blockUser, function(req, res) {
    tribeModel.unblockUser(req, function(result) {
        res.status(200).send(result);
    })
});

customerApi.post('/blockUserList',jwtTokenValidator.validateToken, customerValidator.blockUserList, function(req, res) {
    tribeModel.blockUserList(req, function(result) {
        res.status(200).send(result);
    })
});


customerApi.post('/leaveTribe', customerValidator.leaveTribe, function(req, res) {
    tribeModel.leaveTribe(req, function(result) {
        res.status(200).send(result);
    })
});

customerApi.post('/blockTribe', customerValidator.blockTribe, function(req, res) {
    tribeModel.blockTribe(req, function(result) {
        res.status(200).send(result);
    })
});

customerApi.post('/unBlockTribe', customerValidator.blockTribe, function(req, res) {
    tribeModel.unBlockTribe(req, function(result) {
        res.status(200).send(result);
    })
});

customerApi.post('/blockTribeList', customerValidator.blockTribeList, function(req, res) {
    tribeModel.blockTribeList(req, function(result) {
        res.status(200).send(result);
    })
});




module.exports = customerApi;