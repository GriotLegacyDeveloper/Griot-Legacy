var express = require('express')
var router = express.Router()
var appUsageModel = require('../models/user/app-usage-model')

var appUsageApi = express.Router();
appUsageApi.use(express.json());
appUsageApi.use(express.urlencoded({extended: false}));

router.post('/appUsage', (req,res)=>{
    appUsageModel.appUsage(req, (result)=>{
        res.status(200).send(result)
    })
})

module.exports = router;