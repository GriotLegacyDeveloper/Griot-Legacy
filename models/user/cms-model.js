
var cmsSchema = require('../../schema/Cms');
var contactUsSchema = require('../../schema/ContactUs');
const config = require('../../config');


module.exports = {
    getCms: (req, callBack) => {
        if (req) {
            var data = req.body;
            cmsSchema.findOne({ slug: data.slug }, function (err, result) {
                if (err) {
                    callBack({
                        success: false,
                        STATUSCODE: 422,
                        message: `No data found`,
                        response_data: {}
                    });
                } else {
                    if (result) {
                        callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: `Content`,
                            response_data: { content: result }
                        });
                    } else {
                        callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: `No data found`,
                            response_data: {}
                        });
                    }
                }
            })
        } else {
            callBack({
                success: false,
                STATUSCODE: 422,
                message: `No data found`,
                response_data: {}
            });
        }
    },
    postContact: (req, callBack) => {
        if (req) {
            var data = req.body;
        
            new contactUsSchema(data).save(async function (err, tribeUser) {
                if (err) {
                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Internal DB error',
                        response_data: {}
                    })
                } else {
                    callBack({
                        success: true,
                        STATUSCODE: 200,
                        message: `Thank you for posting your message. We'll get back to you shortly.`,
                        response_data: {}
                    });
                }
            })
        } else {
            callBack({
                success: false,
                STATUSCODE: 422,
                message: `No data found`,
                response_data: {}
            });
        }
    }
}