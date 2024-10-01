const { SERVERURL, HOST, PORT, SERVERIMAGEPATH, SERVERIMAGEUPLOADPATH } = require('../../config/bootstrap');

var session = require('express-session');
var userSchema = require('../../schema/User')
var moment = require('moment')
var appUsageSchema = require('../../schema/Appusage')


module.exports.displayAll = async (req, res) => {
    appUsageSchema.find({})
        .sort({ createdAt: -1 })
        .then(async (users) => {
            console.log("users === ", users)
            res.render('content/appUsage.ejs', {
                users: users
            })

            // return res.status(200).json({
            //     response_data: users
            // })
        })
}