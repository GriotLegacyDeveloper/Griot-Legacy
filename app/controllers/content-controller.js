const { SERVERURL, HOST, PORT, SERVERIMAGEPATH, SERVERIMAGEUPLOADPATH } = require('../../config/bootstrap');
//Session
var session = require('express-session');
const expressFileUpload = require('express-fileupload');
var contentSchema = require('../../schema/Cms');
var adSchema = require('../../schema/Advertisement');

const path = require("path");
const fullPath = path.resolve("./awsConfig.json");
var AWS = require('aws-sdk');
AWS.config.loadFromPath(fullPath);
var config = require('../../config')

var stripe = require('stripe')(config.stripe.secretKey)
var axios = require('axios')

module.exports.contentEdit = async (req, res) => {

    var user = req.session.user;

    var contentId = req.query.id;
    var responseDt = {};

    if (contentId != undefined) {


        contentSchema
            .findOne({ _id: contentId })
            .then(async function (content) {

                if (content != null) {

                    var imagePath = `${SERVERIMAGEPATH}category/`

                    res.render('content/contentEdit.ejs', {
                        content: content, contentId: contentId,
                        layout: false,
                        user: user,
                        serverImagePath: imagePath
                    });


                } else {
                    req.flash('msgLog', 'Something went wrong.');
                    req.flash('msgType', 'danger');
                    res.redirect(req.headers.referer);
                    return;
                }

            });

    }


}
module.exports.contentEditPost = async (req, res) => {

    var reqBody = req.body;



    var contentId = reqBody.contentId;

    var content = reqBody.content;

    // return;

    contentSchema.updateOne({ _id: contentId }, {
        $set: { description: content }
    }, async function (err, result) {
        if (err) {
            console.log(err);
            req.flash('msgLog', 'Something went wrong.');
            req.flash('msgType', 'danger');
            res.redirect(req.headers.referer);
            return;
        } else {
            req.flash('msgLog', 'Content updated successfully.');
            req.flash('msgType', 'success');
            res.redirect('/content/contentList');
            return;
        }
    });


}

module.exports.contentList = (req, res) => {

    var user = req.session.user;

    contentSchema.find({})
        .then(async (contents) => {


            var imagePath = `${SERVERIMAGEPATH}category/`

            res.render('content/contentList.ejs', {
                contents: contents,
                layout: false,
                user: user,
                serverImagePath: imagePath
            });
        });
}

module.exports.adList = (req, res) => {

    var user = req.session.user;


    adSchema.find({})
        .sort({ createdAt: -1 })
        .then(async (ads) => {
            var imagePath = `${SERVERIMAGEPATH}2108/`
            console.log(ads)
            res.render('content/advertisement.ejs', {
                ads: ads,
                serverImagePath: imagePath,
                layout: false,
                user: user
            });
        });
}

module.exports.getAddAdvertisement = (req, res) => {
    var user = req.session.user;

    res.render('content/advertisementAdd.ejs', {
        user: user
    });
}

module.exports.getEditAd = async (req, res) => {
    var id = req.query.id;
    var user = req.session.user;
    console.log("this is id===", id)

    const adData = await adSchema.findOne({ "_id": id })
    console.log("this is adData ==========", adData)
    console.log(adData.trimmedValidFrom);

    res.render('content/advertisementEdit.ejs', {
        user: user,
        adData: adData
    });
}

module.exports.addAdvertisement = async (req, res, next) => {
    console.log(req.body);
    var targetFile = req.files
    //console.log("targetFile",targetFile);return;
    const s3 = new AWS.S3();
    // Binary data base64
    const fileContent = Buffer.from(targetFile.image.data, 'binary');
    var ext = targetFile.image.name.slice(targetFile.image.name.lastIndexOf('.'));
    var fileName = Date.now() + ext;
    const params = {
        Bucket: 'griotlegacy',
        Key: fileName, // File name you want to save as in S3
        Body: fileContent
    };
    s3.upload(params, function (err, dataRes) {
        if (err) {
            console.log("erros", err)
        } else {
            var trimmedValidFrom = req.body.validFrom.substring(0, 10);
            var trimmedValidTill = req.body.validTill.substring(0, 10);
            console.log("this is trimmed valid from======", trimmedValidFrom)


            adSchema.create({
                title: req.body.title,
                link: req.body.link,
                validFrom: req.body.validFrom,
                validTill: req.body.validTill,
                company_name: req.body.company_name,
                email_address: req.body.email_address,
                phone_number: req.body.phone_number,
                address: req.body.address,
                purpose_of_advertisement: req.body.purpose_of_advertisement,
                target_audience: req.body.target_audience,
                trimmedValidFrom: trimmedValidFrom,
                trimmedValidTill: trimmedValidTill,
                image: dataRes.Location,
                imageKey: fileName
            }, (err, data) => {
                if (err) {
                    console.log(err);
                } else {
                    console.log(data)
                }
            });
        }
    })



    res.redirect('/content/advertisements')

}

module.exports.editAd = async (req, res, next) => {
    var id = req.query.id;
    var adDetails = {
        _id: id

    }
    var targetFile = req.files
    console.log("req.files", targetFile);
    console.log("req.body", req.body);

    //console.log("req",req);return;
    adSchema.findOne(adDetails)
        .then(async (item) => {
            if (targetFile == null) {
                const updatedAd = await adSchema.findOneAndUpdate({
                    _id: id
                }, {
                    "$set": {
                        "title": req.body.title,
                        "link": req.body.link,
                        "validFrom": req.body.validFrom,
                        "validTill": req.body.validTill
                    }
                });
            } else {
                if (item != null) {
                    const s3 = new AWS.S3();
                    const params = {
                        Bucket: 'griotlegacy',
                        Key: item.imageKey
                    };
                    s3.deleteObject(params, async (error, data) => {
                        if (error) {
                            req.flash('msgLog', 'Something went wrong.');
                            req.flash('msgType', 'danger');
                            res.redirect(req.headers.referer);
                            return;
                        } else {

                            //var targetFile = req.body.Image
                            const s3 = new AWS.S3();
                            // Binary data base64
                            const fileContent = Buffer.from(targetFile.image.data, 'binary');
                            var ext = targetFile.image.name.slice(targetFile.image.name.lastIndexOf('.'));
                            var fileName = Date.now() + ext;
                            const params = {
                                Bucket: 'griotlegacy',
                                Key: fileName, // File name you want to save as in S3
                                Body: fileContent
                            };
                            s3.upload(params, async function (err, dataRes) {
                                if (err) {
                                    console.log("erros", err)
                                } else {


                                    await adSchema.findOneAndUpdate({
                                        _id: id
                                    }, {
                                        "$set": {
                                            "title": req.body.title,
                                            "link": req.body.link,
                                            "validFrom": req.body.validFrom,
                                            "validTill": req.body.validTill,
                                            "image": dataRes.Location,
                                            "imageKey": fileName
                                        }
                                    });
                                    req.flash('msgLog', 'Advertisement deleted successfully');
                                    req.flash('msgType', 'success');
                                    res.redirect(req.headers.referer);
                                    return;
                                }
                            })
                        }
                    });
                } else {
                    req.flash('msgLog', 'Something went wrong.');
                    req.flash('msgType', 'danger');
                    res.redirect(req.headers.referer);
                    return;
                }
            }

        })


    return res.redirect('/content/advertisements');
}

module.exports.deleteAd = async (req, res) => {
    const id = req.query.id
    var adDetails = {
        _id: id

    }
    adSchema.findOne(adDetails)
        .then(async (item) => {
            if (item != null) {
                const s3 = new AWS.S3();
                const params = {
                    Bucket: 'griotlegacy',
                    Key: item.imageKey
                };
                s3.deleteObject(params, async (error, data) => {
                    if (error) {
                        req.flash('msgLog', 'Something went wrong.');
                        req.flash('msgType', 'danger');
                        res.redirect(req.headers.referer);
                        return;
                    } else {
                        await adSchema.deleteOne({ _id: id });
                        req.flash('msgLog', 'Advertisement deleted successfully');
                        req.flash('msgType', 'success');
                        res.redirect(req.headers.referer);
                        return;
                    }
                });
            } else {
                req.flash('msgLog', 'Something went wrong.');
                req.flash('msgType', 'danger');
                res.redirect(req.headers.referer);
                return;
            }
        })
}

module.exports.adStatus = async (req, res) => {
    var user = req.session.user
    var status = req.query.status
    var id = req.query.id
    var paymentType = req.query.type


    console.log("req.query === ", req.query)

    if (status == 'APPROVED') {
        var statusObj = {
            status: 'APPROVED'
        }

        adSchema.updateOne({ _id: id }, {
            $set: statusObj
        }, (err, resp) => {
            if (err) {
                req.flash('msgLog', 'Something went wrong');
                req.flash('msgType', 'danger');
                res.redirect('/content/advertisements')
            } else {
                req.flash('msgLog', 'Advertisement has been approved')
                req.flash('msgType', 'success')
                res.redirect('/content/advertisements')
                return
            }
        })
    } else if (status == 'REJECTED') {
        try {

            var paymentIntentId = req.query.paymentIntentId
            var amount = parseFloat(req.query.amount)
            var statusObj = {
                status: 'REJECTED'
            }

            if (paymentType == 'STRIPE') {

                // retrieve payment intent
                const paymentIntent = await stripe.paymentIntents.retrieve(paymentIntentId)

                //refund the specified amount
                const refund = await stripe.refunds.create({
                    payment_intent: paymentIntentId,
                    amount: paymentIntent.amount,
                })

                // update the payment intent status
                await stripe.paymentIntents.update(paymentIntentId, {
                    metadata: { refundedAmount: paymentIntent.amount }
                })
            } else if (paymentType == 'PAYPAL') {
                const authString = Buffer.from(`${config.paypal.clientId}:${config.paypal.secret}`).toString('base64')
                console.log("<auth string>", authString)
                try {
                    const res = await axios.post('https://api.sandbox.paypal.com/v1/oauth2/token', 'grant_type=client_credentials', {
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'Authorization': `Basic ${authString}`
                        }
                    })

                    console.log("access token -- ", res.data.access_token)

                    const response = await axios.post(`https://api.sandbox.paypal.com/v2/payments/captures/${paymentIntentId}/refund`, {
                        amount: {
                            value: amount,
                            currency_code: 'USD'
                        }
                    }, {
                        headers: {
                            'Content-Type': 'application/json',
                            'Authorization': `Bearer ${res.data.access_token}`
                        }
                    })

                    console.log("<<<<response>>>>", response.data)
                } catch (err) {
                    console.log("<<catch err 1>>>", err)
                    // console.log(":::", err.data)
                    // return
                }
            }

            adSchema.updateOne({ _id: id }, {
                $set: statusObj
            }, (err, resp) => {
                if (err) {
                    console.log("<<<err>>>", err)
                    req.flash('msgLog', 'Something went wrong');
                    req.flash('msgType', 'danger');
                    res.redirect('/content/advertisements')
                } else {
                    req.flash('msgLog', 'Advertisement has been rejected and the refund has been initiated')
                    req.flash('msgType', 'success')
                    res.redirect('/content/advertisements')
                    return
                }
            })
        } catch (err) {
            console.log("<<<catch err>>>", err)
            req.flash('msgLog', 'Something went wrong');
            req.flash('msgType', 'danger');
            res.redirect('/content/advertisements')
        }

    }


}



function getExtention(filename) {
    return filename.substring(filename.indexOf('.') + 1);
}



