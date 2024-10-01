'use strict';
var express = require('express');
const config = require('../config');
const customerValidator = require('../middlewares/validators/customer/customer-validator');
const postModel = require('../models/user/post-model');
const cmsModel = require('../models/user/cms-model');


const jwtTokenValidator = require('../middlewares/jwt-validation-middlewares');

var customerApi = express.Router();
customerApi.use(express.json());
customerApi.use(express.urlencoded({ extended: false }));



customerApi.post('/createPost', customerValidator.createPost, function (req, res) {
    postModel.createPost(req, function (result) {
        res.status(200).send(result);
    })
});

customerApi.post('/updatePost', customerValidator.updatePost, function (req, res) {
    postModel.updatePost(req, function (result) {
        res.status(200).send(result);
    })
});

customerApi.post('/home', jwtTokenValidator.validateToken, customerValidator.home, function (req, res) {
    postModel.home(req, function (result) {
        res.status(200).send(result);
    })
});

customerApi.post('/removePost', jwtTokenValidator.validateToken, customerValidator.removePost, function (req, res) {
    postModel.removePost(req, function (result) {
        res.status(200).send(result);
    })
});

customerApi.post('/removeImage', jwtTokenValidator.validateToken, customerValidator.removeImage, function (req, res) {
    postModel.removeImage(req, function (result) {
        res.status(200).send(result);
    })
});

customerApi.post('/likePost', jwtTokenValidator.validateToken, customerValidator.likePost, function (req, res) {
    postModel.likePost(req, function (result) {
        res.status(200).send(result);
    })
});

customerApi.post('/unlikePost', jwtTokenValidator.validateToken, customerValidator.likePost, function (req, res) {
    postModel.unlikePost(req, function (result) {
        res.status(200).send(result);
    })
});

customerApi.post('/commentPost', jwtTokenValidator.validateToken, customerValidator.commentPost, function (req, res) {
    postModel.commentPost(req, function (result) {
        res.status(200).send(result);
    })
});

/** Get CMS Pages */
customerApi.post('/getCmsPages', function (req, res) {
    cmsModel.getCms(req, function (result) {
        res.status(200).send(result);
    });
});

/** Post Contact */
customerApi.post('/postContact', function (req, res) {
    cmsModel.postContact(req, function (result) {
        res.status(200).send(result);
    });
});
customerApi.post('/dashboard', jwtTokenValidator.validateToken, customerValidator.dashboard, function (req, res) {
    postModel.dashboard(req, function (result) {
        res.status(200).send(result);
    })
});

customerApi.post('/createAdvertisement', customerValidator.createAdvertisement, function (req, res) {
    postModel.createAdvertisement(req, function (result) {
        res.status(200).send(result);
    })
});
customerApi.post('/getAdvertisement', function (req, res) {
    postModel.getAdvertisement(req, function (result) {
        res.status(200).send(result);
    })
});
customerApi.post('/deleteAd', function (req, res) {
    postModel.deleteAd(req.body, function (result) {
        res.status(200).send(result)
    })
});
customerApi.post('/cancelAd', function (req, res) {
    postModel.cancelAd(req.body, function (result) {
        res.status(200).send(result)
    })
})

customerApi.post('/editAdvertisement', function (req, res) {
    postModel.editAdvertisement(req, function (result) {
        res.status(200).send(result)
    })
})


module.exports = customerApi;