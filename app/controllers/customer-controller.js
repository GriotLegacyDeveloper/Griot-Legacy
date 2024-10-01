const { validationResult } = require('express-validator');
const bcrypt = require('bcryptjs');
const mail = require('../../modules/sendEmail');
const { SERVERURL, HOST, PORT, SERVERIMAGEPATH, SERVERIMAGEUPLOADPATH } = require('../../config/bootstrap');
var awsConfig = require('../../awsConfig.json')
var momentTz = require("moment-timezone")
const path = require("path");
const fullPath = path.resolve("./awsConfig.json");
var AWS = require('aws-sdk')
AWS.config.loadFromPath(fullPath);

console.log("FULL PATH : ", fullPath)

var moment = require("moment")
var axios = require('axios')


AWS.config.update({
    accessKeyId: awsConfig.accessKeyId,
    secretAccessKey: awsConfig.secretAccessKey,
    region: awsConfig.region
})


//Session
var session = require('express-session');


var userSchema = require('../../schema/User');
var userPostSchema = require('../../schema/UserPost');
var postCommentSchema = require('../../schema/Comment')
var userFileSchema = require('../../schema/UserFile');
var UserDeviceLoginSchema = require('../../schema/UserDeviceLogin');
var storageSchema = require('../../schema/storageSchema')

module.exports.customerList = (req, res) => {

    var user = req.session.user;



    userSchema.find()
        .sort({ createdAt: -1 })
        .then(async (customers) => {

            var imagePath = `${SERVERIMAGEPATH}2108/`

            res.render('customer/customerList.ejs', {
                customers: customers, serverImagePath: imagePath,
                layout: false,
                user: user,
                momentTz: momentTz,
                moment: moment
            });
        });
}

module.exports.customerStatus = (req, res) => {

    var user = req.session.user;

    var status = req.query.status;
    var id = req.query.id;
    console.log('status', status);

    if (status == 'ACTIVE') {
        var statusObj = {
            status: 'INACTIVE'
        }
    } else {
        var statusObj = {
            status: 'ACTIVE'
        }
    }

    userSchema.updateOne({ _id: id }, {
        $set: statusObj
    }, function (err, resp) {
        if (err) {
            req.flash('msgLog', 'Something went wrong.');
            req.flash('msgType', 'danger');
            res.redirect('/customer/customerList');
            return;
        } else {
            req.flash('msgLog', 'Status changed successfully.');
            req.flash('msgType', 'success');
            res.redirect('/customer/customerList');
            return;
        }

    })

}

// Edit from Mannmohan 13-09-2022

module.exports.getAddCustomer = async (req, res) => {
    res.render('customer/customerAdd.ejs');
}

module.exports.addNewCustomer = async (req, res, next) => {

    if (req.body.fullName == '' || req.body.email == '' || req.body.pass1 == '' || req.body.pass2 == '' || req.body.dob == '' || req.body.countryCode == '' || req.body.phone == '') {
        // console.log(data)
        req.flash('msgLog', 'Please enter the required details');
        req.flash('msgType', 'danger');
        res.redirect('/customer/addNewCustomer');
        return;
    } else {


        console.log("ADD SUBMITTED")

        var targetFile = req.files
        console.log("targetFile", targetFile);
        console.log("Body", req.body);
        const s3 = new AWS.S3();
        // Binary data base64
        const fileContent = Buffer.from(targetFile.profileImage.data, 'binary');
        var ext = targetFile.profileImage.name.slice(targetFile.profileImage.name.lastIndexOf('.'));
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
                // var trimmedValidFrom = req.body.validFrom.substring(0,10);
                //             var trimmedValidTill = req.body.validTill.substring(0,10);
                //             console.log("this is trimmed valid from======", trimmedValidFrom)
                var passowrd = req.body.pass1;
                var passowrd1 = req.body.pass2;
                var finalPass = ''

                if (passowrd == passowrd1) {
                    finalPass = passowrd
                }
                console.log('Pass1', passowrd);
                console.log('Pass2', passowrd1);
                console.log('Pass', finalPass);

                userSchema.create({
                    fullName: req.body.fullName,
                    email: req.body.email,
                    countryCode: req.body.countryCode,
                    phone: req.body.phone,
                    password: finalPass,
                    dateOfBirth: req.body.dob,
                    profileImage: dataRes.Location,
                    gender: req.body.gender,
                    relationship: req.body.relationship,
                    status: 'INACTIVE',
                    userLoginType: 'EMAIL',
                }, (err, data) => {
                    if (err) {
                        console.log(err);
                    } else {
                        console.log(data)
                        req.flash('msgLog', 'Added successfully.');
                        req.flash('msgType', 'success');
                        res.redirect('/customer/customerList');
                        return;
                    }
                });
            }
        })
    }



    // res.redirect('/customer/customerList')

}

module.exports.customerPostView = async (req, res) => {

    console.log(req.query)
    var id = req.query.id
    var userId = req.query.userId
    const uData = {
        userId: id
    }
    console.log("ID", uData)
    const postData = await userPostSchema.find({ "userId": id })
    const userData = await userSchema.findOne({ "_id": id })
    const userDataNew = await userSchema.findOne({ "_id": userId })

    const newData = await userPostSchema.aggregate(
        [
            { $match: { userId: userId } },
            {
                $project: {
                    _id: 1,
                    likes: 1,
                    share: 1,
                    comments: 1,
                    caption: 1,
                }

            },
            {
                $lookup: {
                    from: "userfiles",
                    localField: "caption",
                    foreignField: "caption",
                    as: "touser",
                }
            },
            {
                $project: {
                    likes: "$likes",
                    share: "$share",
                    comments: "$comments",
                    caption: "$caption",
                    album: "$touser.album",
                    thumb: "$touser.thumb",
                    file: "$touser.file",
                    type: "$touser.type"
                }
            }
        ]
    )

    var isBlocked = await userPostSchema.findOne({ userId: userId }, 'isBlocked')
    console.log("=-=-=-=-=", isBlocked)

    var redirectUrl = '/customer/customerViewPost?id=' + req.query.id + '&userId=' + req.query.userId

    const imgData = await userPostSchema.aggregate(
        [
            { $match: { userId: id } },
            {
                $project: {
                    _id: 1,
                    likes: 1,
                    share: 1,
                    comments: 1,
                    caption: 1,
                }

            },
            {
                $lookup: {
                    from: "userfiles",
                    localField: "caption",
                    foreignField: "caption",
                    as: "touser",
                }
            },
            {
                $project: {
                    likes: "$likes",
                    share: "$share",
                    comments: "$comments",
                    caption: "$caption",
                    album: "$touser.album",
                    thumb: "$touser.thumb",
                    file: "$touser.file",
                    type: "$touser.type"
                }
            }
        ]
    )
    console.log("this is postData ==========", newData)
    console.log("this is userData =========", userDataNew)

    for (let img of imgData) {
        if (img.thumb) {
            if (img.thumb.length > 0) {
                for (let thumb of img.thumb) {
                    if (thumb != '') {
                        console.log("this is thumb-=-=-=-=-=-=-=-=", thumb)
                    }
                }
            }
        } else if (img.file) {
            if (img.file.length > 0) {
                for (let file of img.file) {
                    if (file != '') {
                        console.log("this is file =-=-=-=-=-=-=-=--=", file)
                    }
                }
            }
        }
    }

    if (imgData.length > 0) {
        console.log("OKAY");
        res.render('customer/customerPostView.ejs', {
            user: userData,
            postData: imgData,
            message: ''
        });
    } else {
        if (newData) {
            console.log("OKAY 22")
            if (isBlocked.isBlocked == false) {
                req.flash('msgLog', 'Unblocked Successfully')
                req.flash('msgType', 'success');
                res.render('customer/customerPostView.ejs', {
                    user: userDataNew,
                    postData: newData,
                    message: req.flash('msgLog')
                });

            } else {
                req.flash('msgLog', 'Blocked Successfully')
                req.flash('msgType', 'success');
                res.render('customer/customerPostView.ejs', {
                    user: userDataNew,
                    postData: newData,
                    message: req.flash('msgLog')
                });

            }
        } else {
            req.flash('msgLog', 'No posts yet.');
            req.flash('msgType', 'danger');
            res.redirect('/customer/customerList');

        }
    }


}

module.exports.getPostDetails = async (req, res) => {
    var id = req.query.id
    const pData = {
        postId: id
    }
    console.log('PID: ', pData);
    const currentPost = await userPostSchema.findOne({ "_id": id })
    const imageData = await userFileSchema.find(pData)
    const postComments = await postCommentSchema.find(pData)
    const pComments = await postCommentSchema.aggregate(
        [
            {
                $match: {
                    _id: { $in: currentPost.comments }
                }
            },
            {
                $project: {
                    commentedBy: 1,
                    comment: 1
                }
            },
            {
                $lookup: {
                    from: "users",
                    localField: "commentedBy",
                    foreignField: "_id",
                    as: "commentUser"
                }
            },
            {
                $project: {
                    userName: "$commentUser.fullName",
                    comment: "$comment"
                }
            }
        ]
    )

    console.log('IData', imageData);
    console.log('pData', currentPost);
    // console.log('cData', postComments);
    // console.log('cmtData', pComments);
    res.render('customer/customerPost.ejs', {
        currentPost: currentPost,
        imageData: imageData,
        comments: postComments,
        cUser: pComments
    });
}

module.exports.getEditCustomerPost = async (req, res) => {
    var id = req.query.id;
    var user = req.session.user;
    console.log("this is id===", id)

    const postData = await userSchema.findOne({ "_id": id })
    console.log("this is adData ==========", postData)
    // console.log(adData.trimmedValidFrom);

    res.render('customer/customerEdit.ejs', {
        user: user,
        postData: postData
    });
}

module.exports.makeEdits = async (req, res, next) => {
    var id = req.query.id
    var userDetails = {
        _id: id
    }
    var targetFile = req.files
    console.log('userDetails', userDetails);
    console.log('targetFiles', targetFile);
    console.log('req.body', req.body);

    await userSchema.findOne(userDetails)
        .then(async (item) => {
            console.log('item', item)
            if (targetFile == null) {
                await userSchema.updateOne({
                    _id: id
                }, {
                    "$set": {
                        "fullName": req.body.fullName,
                        "email": req.body.email,
                        "countryCode": req.body.countryCode,
                        "phone": req.body.phone,
                        "relationship": req.body.relationship
                    }
                });
            } else {
                if (item != null && item.profileImage != '') {
                    console.log("Has Image");
                    const s3 = new AWS.S3();
                    const params = {
                        Bucket: 'griotlegacy',
                        Key: item.profileImage
                    };
                    s3.deleteObject(params, async (error, data) => {
                        if (error) {
                            req.flash('msgLog', 'Something went wrong.');
                            req.flash('msgType', 'danger');
                            res.redirect(req.headers.referer);
                            return;
                        } else {
                            const s3 = new AWS.S3();
                            const fileContent = Buffer.from(targetFile.profileImage.data, 'binary');
                            var ext = targetFile.profileImage.name.slice(targetFile.profileImage.name.lastIndexOf('.'));
                            console.log("ext=-=-=-=-=-=", ext)

                            var fileName = Date.now() + ext;
                            const params = {
                                Bucket: 'griotlegacy',
                                Key: fileName,
                                Body: fileContent
                            };
                            s3.upload(params, async function (err, dataRes) {
                                if (err) {
                                    console.log('Error123', err);
                                } else {
                                    await userSchema.findOneAndUpdate({
                                        _id: id
                                    }, {
                                        "$set": {
                                            "fullName": req.body.fullName,
                                            "email": req.body.email,
                                            "countryCode": req.body.countryCode,
                                            "phone": req.body.phone,
                                            "relationship": req.body.relationship,
                                            "profileImage": dataRes.Location
                                        }
                                    });
                                    req.flash('msgLog', 'ProfileImage deleted successfully');
                                    req.flash('msgType', 'success');
                                    // res.redirect(req.headers.referer);
                                    return;
                                }
                            })
                        }
                    });
                } else {
                    console.log('No Image');
                    const s3 = new AWS.S3();
                    const fileContent = Buffer.from(targetFile.profileImage.data, 'binary');
                    var ext = targetFile.profileImage.name.slice(targetFile.profileImage.name.lastIndexOf('.'));
                    var fileName = Date.now() + ext;
                    const params = {
                        Bucket: 'griotlegacy',
                        Key: fileName,
                        Body: fileContent
                    };
                    s3.upload(params, async function (err, dataRes) {
                        if (err) {
                            console.log('Error345', err);
                        } else {
                            await userSchema.findOneAndUpdate({
                                _id: id
                            }, {
                                "$set": {
                                    "fullName": req.body.fullName,
                                    "email": req.body.email,
                                    "countryCode": req.body.countryCode,
                                    "phone": req.body.phone,
                                    "relationship": req.body.relationship,
                                    "profileImage": dataRes.Location
                                }
                            });
                            req.flash('msgLog', 'ProfileImage added successfully');
                            req.flash('msgType', 'success');
                            return;
                        }
                    });
                }
            }
        })

    return res.redirect('/customer/customerList');
}

module.exports.customerDelete = async (req, res) => {
    const id = req.query.id
    var postDetails = {
        _id: id

    }
    const uData = await userSchema.findOne(postDetails);
    console.log(uData.isDeleted);

    if (uData.isDeleted == false || uData.isDeleted == undefined) {
        console.log('Okay');

        var deleteObj = {
            isDeleted: true
        }

        userSchema.updateOne({ _id: id }, {
            $set: deleteObj
        }, function (err, resp) {
            if (err) {
                req.flash('msgLog', 'Something went wrong.');
                req.flash('msgType', 'danger');
                res.redirect('/customer/customerList');
                return;
            } else {
                req.flash('msgLog', 'Deleted successfully.');
                req.flash('msgType', 'success');
                res.redirect('/customer/customerList');
                return;
            }

        })
    }

}

module.exports.postBlock = async (req, res) => {
    var id = req.query.id;
    var block = req.query.blocked;
    var userId = req.query.userId
    var redirectUrl = '/customer/customerViewPost?id=' + req.query.id + '&userId=' + userId
    if (block == 'false') {
        var blockObj = {
            isBlocked: true
        }
        console.log('okay false');
    } else {
        var blockObj = {
            isBlocked: false
        }
    }

    userPostSchema.updateOne({ _id: id }, {
        $set: blockObj
    }, function (err, resp) {
        if (err) {
            req.flash('msgLog', 'Something went wrong.');
            req.flash('msgType', 'danger');
            res.redirect(redirectUrl);
            return;
        } else {
            // req.flash('msgLog', 'Blocked successfully.');
            // req.flash('msgType', 'success');
            res.redirect(redirectUrl);
            return;
        }

    })


}

module.exports.trackStorage = async(req, res)=>{
    const s3 = new AWS.S3()
    console.log("INSIDE TRACK STORAGE")
    const id = req.query.id
    var storageArr = []
    const storageData = await storageSchema.find({}).sort({createdAt: -1})

    for(let storage of storageData){
        const userData = await userSchema.findOne({_id: storage.user})

        const apiUrl = 'https://app.griotlegacy.com:2109/api/user/trackStorage'
        const data = {
            userId: userData._id
        };
        console.log("DATA : ", data)
        await axios.post(apiUrl, data).then(response=>{

            if(response.data.STATUSCODE == 200){
                console.log("11")

            var storageObj = {
                name : userData.fullName,
                email : userData.email,
                initial: '1.00 GB',
                current: response.data.response_data.totalStorage,
                used: response.data.response_data.totalStorageUsed,
                remaining: response.data.response_data.availableStorage
            }
        } else {
            console.log("00")
            var storageObj = {
                name : userData.fullName,
                email : userData.email,
                initial: '1.00 GB',
                current: "",
                used: "",
                remaining: ""
            }
        }
            console.log("OBJECT : ", storageObj)
            storageArr.push(JSON.parse(JSON.stringify(storageObj)))
        })
        .catch(err=>{
            console.log("ERROR :", err)
        })

        
    }

    console.log("ARRAY : ", storageArr)

    var imagePath = `${SERVERIMAGEPATH}2108/`

            res.render('customer/trackStorage.ejs', {
                storageData: storageArr, 
                serverImagePath: imagePath,
                layout: false,
                // user: user
            });
}