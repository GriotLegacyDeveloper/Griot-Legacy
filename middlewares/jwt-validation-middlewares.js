var jwt = require('jsonwebtoken');
const config = require('../config');
var userDeviceSchema = require('../schema/UserDeviceLogin');
var userSchema = require('../schema/User');
/**
 * @developer : Subhajit Singha
 * @date : 17th April 2020
 * @description : Middleware function for validating request data and JWT token.
 */
exports.validateToken = async (req, res, next) => {
    var token = req.headers['authorization'];
    if (token) {

        if (token.startsWith('Bearer ') || token.startsWith('bearer ')) {
            // Remove Bearer from string
            token = token.slice(7, token.length);
        }
        // decode token
 
        if (token) {
            jwt
                .verify(token, config.secretKey, function (err, decoded) {
                    if (err) {
                        console.log(err);
                        res.status(200).send({
                            success: false,
                            STATUSCODE: 401,
                            message: 'Token not valid',
                            response_data: {}
                        });
                    }
                    else {
                        var userId = req.body.userId;
                        var loginId = req.body.loginId;
                        var appType = req.body.appType;
                        
                        console.log('userId',userId);
                        // return;
                        console.log('decoded.subject',decoded.subject);
                        //VALID USER CHECK
                        if (userId != decoded.subject) {
                            res.status(200).send({
                                success: false,
                                STATUSCODE: 403,
                                message: 'Request info not valid',
                                response_data: {}
                            });
                        } else { //LOGIN CHECK

                            userDeviceSchema.findOne({_id: loginId,  userId: userId, appType: appType })
                                .then(async function (loginres) {
                                    if (loginres != null) {
                                        
                                        //CHECK BLOCK USER
                                        var userData = await userSchema.findOne({ _id: userId, status: {$in:['WAITING FOR APPROVAL','BLOCK']}});
                                        if (userData != null) {
                                            res.status(200).send({
                                                success: false,
                                                STATUSCODE: 403,
                                                message: 'Your account has been deactivated, please contact admin',
                                                response_data: {}
                                            });
                                        } else {
                                            next();
                                        }
                                    } else {
                                        res.status(200).send({
                                            success: false,
                                            STATUSCODE: 403,
                                            message: 'User not logged in',
                                            response_data: {}
                                        });
                                    }
                                })
                                .catch(function (err) {
                                    console.log('err',err);
                                    res.status(200).send({
                                        success: false,
                                        STATUSCODE: 500,
                                        message: 'Something went wrong',
                                        response_data: {}
                                    });
                                });
                        }
                    }
                });

        } else {
            res.status(200).send({
                success: false,
                STATUSCODE: 403,
                message: 'Token format not valid',
                response_data: {}
            });

        }
    } else {
        res.status(200).send({
            success: false,
            STATUSCODE: 403,
            message: 'Token format not valid',
            response_data: {}
        });

    }


}