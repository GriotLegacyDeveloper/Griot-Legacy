
var userSchema = require('../../schema/User');
var userPostSchema = require('../../schema/UserPost');
var userFileSchema = require('../../schema/UserFile');
var mapUserTribeSchema = require('../../schema/MapUserTribe');
var mapUserInnerCircleSchema = require('../../schema/MapUserInnerCircle');
var tribeSchema = require('../../schema/Tribe');
var LikeSchema = require('../../schema/Like');
var CommentSchema = require('../../schema/Comment');
var userNotificationSchema = require('../../schema/UserNotification');
var advertisementSchema = require('../../schema/Advertisement');
var userDeviceLoginSchema = require('../../schema/UserDeviceLogin');
const config = require('../../config');
const path = require("path");
const fullPath = path.resolve("./awsConfig.json");
var AWS = require('aws-sdk');
AWS.config.loadFromPath(fullPath);
var _async = require("async");

module.exports = {
    // createPost: (req, callBack) => {
    //     if (req) {
    //         var data = req.body;
    //         var postImages = req.files;
    //         userSchema.findOne({ _id: data.userId }, async function (err, result) {
    //             if (err) {
    //                 console.log('err', err);
    //                 callBack({
    //                     success: false, 
    //                     STATUSCODE: 500,
    //                     message: 'Something went wrong',
    //                     response_data: {}
    //                 });
    //             } else {
    //                 if (result) {
    //                     var tribeIdArr = (data.tribeId).split(",");
    //                     var userPostObj = {
    //                         userId: result._id,
    //                         caption: data.caption,
    //                         postType: data.postType,
    //                         audience: data.audience,
    //                         tribe: tribeIdArr
    //                     }
    //                     new userPostSchema(userPostObj).save(async function (err, userPost) {
    //                         if (err) {
    //                             callBack({
    //                                 success: false,
    //                                 STATUSCODE: 500,
    //                                 message: 'Something went wrong',
    //                                 response_data: {}
    //                             });
    //                         } else {
    //                             if (postImages != null) {
    //                                 // console.log("images ", postImages)
    //                                 var imgFnd = 0;
    //                                 if (Array.isArray(postImages.image) == true) {
    //                                     var postImagesAllImgs = postImages.image;
    //                                     imgFnd++;
    //                                 } else {
    //                                     var postImagesAllImgs = [];
    //                                     var postImagesAllImgsObj = postImages.image;
    //                                     postImagesAllImgs.push(postImagesAllImgsObj);
    //                                     imgFnd++;
    //                                 }
    //                                 if (postImagesAllImgs.length > 0) {
    //                                     var userPostDocumentObjArr = [];
    //                                     var imgExErr = 0;
    //                                     var imgUp = 0;
    //                                     var postImgLength = postImagesAllImgs.length;
    //                                     _async.forEach(Object.keys(postImagesAllImgs), function (itemKey, CallBack) {
    //                                         var postImagesAllImg = postImagesAllImgs[itemKey];
    //                                         console.log("postImagesAllImgs", postImagesAllImgs)
    //                                         var filename = postImagesAllImg.name;
    //                                         var fileArr = filename.split(".");
    //                                         if (fileArr.length == 2) {
    //                                             var ext = fileArr[1];
    //                                         } else if (fileArr.length == 3) {
    //                                             var ext = fileArr[2];
    //                                         } else {
    //                                             var ext = fileArr[1];
    //                                         }
    //                                         if (!["JPG", "JPEG", "PNG", "jpg", "jpeg", "bmp", "gif", "png", "x-png", "avi", "flv", "wmv", "mp4", "mov", "MOV", "MP4"].includes(ext)) {
    //                                             CallBack()
    //                                         } else {
    //                                             var userImagesObj = {
    //                                                 userId: result._id,
    //                                                 postId: userPost._id,
    //                                                 album: data.album,
    //                                                 caption: data.caption,
    //                                                 arrange: itemKey
    //                                             }
    //                                             const s3 = new AWS.S3();
    //                                             // Binary data base64
    //                                             const fileContent = Buffer.from(postImagesAllImg.data, 'binary');
    //                                             var fileName = Date.now() + "." + ext;
    //                                             const params = {
    //                                                 Bucket: 'griotlegacy',
    //                                                 Key: fileName, // File name you want to save as in S3
    //                                                 Body: fileContent
    //                                             };
    //                                             s3.upload(params, function (err, dataRes) {
    //                                                 if (err) {
    //                                                     CallBack()
    //                                                 } else {
    //                                                     userImagesObj.file = dataRes.Location;
    //                                                     console.log('datares ', dataRes)
    //                                                     if (["jpg", "jpeg", "bmp", "gif", "png", "x-png"].includes(ext)) {
    //                                                         userImagesObj.type = 'IMAGE'
    //                                                         userImagesObj.thumb = '';
    //                                                         userPostDocumentObjArr.push(userImagesObj);
    //                                                         CallBack()
    //                                                     } else {
    //                                                         const s3 = new AWS.S3();
    //                                                         var thumbImagesAllImg = req.files.thumb;
    //                                                         const fileContent = Buffer.from(thumbImagesAllImg.data, 'binary');
    //                                                         var ext1 = thumbImagesAllImg.name.slice(thumbImagesAllImg.name.lastIndexOf('.'));
    //                                                         var fileName = Date.now() + ext1;
    //                                                         // Setting up S3 upload parameters
    //                                                         const params = {
    //                                                             Bucket: 'griotlegacy',
    //                                                             Key: fileName, // File name you want to save as in S3
    //                                                             Body: fileContent
    //                                                         };
    //                                                         // Uploading files to the bucket
    //                                                         s3.upload(params, function (err, dataRes1) {
    //                                                             if (err) {
    //                                                                 console.log("errThumb", err);
    //                                                                 userImagesObj.type = 'VIDEO'
    //                                                                 userImagesObj.thumb = '';
    //                                                             } else {
    //                                                                 console.log("dataRes1", dataRes1.Location);
    //                                                                 userImagesObj.type = 'VIDEO'
    //                                                                 userImagesObj.thumb = dataRes1.Location;
    //                                                             }
    //                                                             userPostDocumentObjArr.push(userImagesObj);
    //                                                             CallBack()
    //                                                         })
    //                                                     }
    //                                                 }
    //                                             })
    //                                         }
    //                                     }, function (err, cont) {
    //                                         if (err) {
    //                                             callBack({
    //                                                 success: false,
    //                                                 STATUSCODE: 500,
    //                                                 message: 'Something went wrong',
    //                                                 response_data: {}
    //                                             });
    //                                         } else {
    //                                             userFileSchema.insertMany(userPostDocumentObjArr, async function (err, postDocresult) {
    //                                                 if (err) {
    //                                                     console.log(err);
    //                                                     callBack({
    //                                                         success: false,
    //                                                         STATUSCODE: 500,
    //                                                         message: 'Something went wrong',
    //                                                         response_data: {}
    //                                                     });
    //                                                 } else {
    //                                                     if (postDocresult) {
    //                                                         await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'FILE' } });
    //                                                         callBack({
    //                                                             success: true,
    //                                                             STATUSCODE: 200,
    //                                                             message: 'Post added successfully',
    //                                                             response_data: {}
    //                                                         });
    //                                                     }
    //                                                 }
    //                                             });

    //                                         }
    //                                     })
    //                                 } else {
    //                                     await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

    //                                     callBack({
    //                                         success: true,
    //                                         STATUSCODE: 200,
    //                                         message: 'Post added successfully',
    //                                         response_data: {}
    //                                     });
    //                                 }

    //                             } else {
    //                                 await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

    //                                 callBack({
    //                                     success: true,
    //                                     STATUSCODE: 200,
    //                                     message: 'Post added successfully',
    //                                     response_data: {}
    //                                 });
    //                             }

    //                         }
    //                     });


    //                 } else {
    //                     callBack({
    //                         success: false,
    //                         STATUSCODE: 422,
    //                         message: 'User not found',
    //                         response_data: {}
    //                     });
    //                 }
    //             }
    //         });

    //     }
    // },
    createPost: async (req, callBack) => {
        if (!req) {
            callBack({
                success: false,
                STATUSCODE: 400,
                message: 'Invalid request data',
                response_data: {}
            });
            return;
        }

        const data = req.body;
        const postImages = req.files;


        try {
            // Get the user's storage size limit from the database
            const user = await userSchema.findOne({ _id: data.userId });
            if (!user) {
                callBack({
                    success: false,
                    STATUSCODE: 422,
                    message: 'User not found',
                    response_data: {}
                });
                return;
            }
            var tribeIdArr = (data.tribeId).split(",");
            var userPostObj = {
                userId: data.userId,
                caption: data.caption,
                postType: data.postType,
                audience: data.audience,
                tribe: tribeIdArr
            }
            new userPostSchema(userPostObj).save(async (err, result) => {
                if (err) {
                    console.log("Save err :", err)
                    callBack({
                        success: false,
                        STATUSCODE: 400,
                        message: "Something went wrong",
                        response_data: {}
                    })
                } else {
                    const storageLimit = user.storageLimit || 1 * 1024 * 1024 * 1024; // Default 1GB
                    const userFolder = `${user._id}/`;
                    const s3 = new AWS.S3();
                    const listObjectsResponse = await s3.listObjectsV2({ Bucket: 'griotlegacy', Prefix: userFolder }).promise();
                    console.log("S3 object response :", listObjectsResponse.Contents)
                    // Create or check user's folder in S3  

                    if (listObjectsResponse.Contents.length === 0) {
                        console.log(0)
                        // User's folder doesn't exist, create it
                        await s3.putObject({
                            Bucket: 'griotlegacy',
                            Key: userFolder,
                            Body: '',
                            ACL: 'private',
                            Metadata: {
                                'x-amz-meta-storage-size-limit': storageLimit.toString(),
                            },
                        }).promise();
                    }
                    // Calculate total size of files being uploaded
                    let totalSize = 0;
                    const filePromises = [];
                    var imageArr = []
                    var thumbArr = []
                    if (Array.isArray(postImages.image) === true) {
                        var fileObjects = postImages.image.map(async (postImage, index) => {
                            const fileContent = Buffer.from(postImage.data, 'binary');
                            totalSize += fileContent.length;
                            var fileArr = postImage.name.split('.')
                            var fileProperties = await uploadFileToS3(s3, userFolder, postImage) // Spread uploaded file properties

                            if (fileArr[1] == "jpg" || fileArr[1] == "jpeg" || fileArr[1] == "bmp" || fileArr[1] == "gif" || fileArr[1] == "png" || fileArr[1] == "x-png") {
                                var fileType = 'IMAGE'
                                var thumb = ''
                            } else {
                                var fileType = 'VIDEO'
                                if (Array.isArray(postImages.thumb) == true) {
                                    var thumbFile = postImages.thumb[index]
                                    var thumbProperties = await uploadFileToS3(s3, userFolder, thumbFile)
                                    var thumb = thumbProperties.file
                                } else {
                                    var thumbProperties = await uploadFileToS3(s3, userFolder, postImages.thumb)
                                    var thumb = thumbProperties.file
                                }
                            }

                            // console.log("fileProperties ==>", fileProperties)
                            return {
                                userId: data.userId,
                                postId: result._id.toString(),
                                caption: data.caption,
                                album: data.album,
                                arrange: index,
                                file: fileProperties.file,
                                type: fileType,
                                thumb: thumb
                            };
                        });

                    } else {
                        imageArr.push(postImages.image)
                        // thumbArr.push(postImages.thumb)
                        var fileObjects = imageArr.map(async (postImage, index) => {
                            const fileContent = Buffer.from(postImage.data, 'binary');
                            totalSize += fileContent.length;
                            var fileArr = postImage.name.split('.')

                            var fileProperties = await uploadFileToS3(s3, userFolder, postImage) // Spread uploaded file properties
                            // console.log("fileProperties ==>", fileProperties)
                            if (fileArr[1] == "jpg" || fileArr[1] == "jpeg" || fileArr[1] == "bmp" || fileArr[1] == "gif" || fileArr[1] == "png" || fileArr[1] == "x-png") {
                                var fileType = 'IMAGE'
                                var thumb = ''
                            } else {
                                var fileType = 'VIDEO'
                                var thumbProperties = await uploadFileToS3(s3, userFolder, postImages.thumb)
                                var thumb = thumbProperties.file
                            }
                            return {
                                userId: data.userId,
                                postId: result._id.toString(),
                                caption: data.caption,
                                album: data.album,
                                arrange: index,
                                file: fileProperties.file,
                                type: fileType,
                                thumb: thumb
                            };
                        });
                    }

                    filePromises.push(...fileObjects);
                    const totalSizeInBytes = totalSize;
                    const totalSizeInMB = totalSizeInBytes / (1024 * 1024);
                    // Calculate storage used by the user in S3
                    const storageUsedInS3 = listObjectsResponse.Contents.reduce((acc, obj) => acc + obj.Size, 0);

                    // Calculate remaining storage
                    const remainingStorage = storageLimit - (storageUsedInS3 + totalSizeInBytes);
                    if (remainingStorage < 0) {
                        console.log("00")
                        callBack({
                            success: false,
                            STATUSCODE: 400,
                            message: 'User has exceeded storage limit. Please buy more storage.',
                            response_data: {}
                        });
                        return;
                    }
                    const userPostDocumentObjArr = await Promise.all(filePromises);

                    console.log("array =>", userPostDocumentObjArr)
                    var postData = await userFileSchema.insertMany(userPostDocumentObjArr);
                    callBack({
                        success: true,
                        STATUSCODE: 200,
                        message: 'Post added successfully',
                        response_data: {}
                    });
                }
            })

        } catch (error) {
            console.error('Error in createPost:', error);
            callBack({
                success: false,
                STATUSCODE: 500,
                message: 'Something went wrong',
                response_data: {}
            });
        }
    },

    createAdvertisement: (req, callBack) => {
        if (req) {
            var data = req.body;
            var postImages = req.files;
            userSchema.findOne({ _id: data.userId }, async function (err, result) {
                if (err) {
                    console.log('err', err);
                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Something went wrong',
                        response_data: {}
                    });
                } else {
                    if (result) {
                        // var tribeIdArr = (data.tribeId).split(",");
                        // var advertisementObj = {
                        //     userId: result._id,
                        //     caption: data.caption,
                        //     postType: data.postType,
                        //     audience: data.audience,
                        //     tribe: tribeIdArr
                        // }
                        if (postImages != null) {
                            console.log("images ", postImages)
                            var imgFnd = 0;
                            if (Array.isArray(postImages.image) == true) {
                                var postImagesAllImgs = postImages.image;
                                imgFnd++;
                            } else {
                                var postImagesAllImgs = [];
                                var postImagesAllImgsObj = postImages.image;
                                postImagesAllImgs.push(postImagesAllImgsObj);
                                imgFnd++;
                            }
                            if (postImagesAllImgs.length > 0) {
                                var userPostDocumentObjArr = [];
                                var imgExErr = 0;
                                var imgUp = 0;
                                var postImgLength = postImagesAllImgs.length;
                                _async.forEach(Object.keys(postImagesAllImgs), function (itemKey, CallBack) {
                                    var postImagesAllImg = postImagesAllImgs[itemKey];
                                    console.log("postImagesAllImgs", postImagesAllImgs)
                                    var filename = postImagesAllImg.name;
                                    var fileArr = filename.split(".");
                                    if (fileArr.length == 2) {
                                        var ext = fileArr[1];
                                    } else if (fileArr.length == 3) {
                                        var ext = fileArr[2];
                                    } else {
                                        var ext = fileArr[1];
                                    }
                                    if (!["JPG", "JPEG", "PNG", "jpg", "jpeg", "bmp", "gif", "png", "x-png", "avi", "flv", "wmv", "mp4", "mov", "MOV", "MP4"].includes(ext)) {
                                        CallBack()
                                    } else {
                                        const [fromDay, fromMonth, fromYear] = data.validFrom.split('/')
                                        const [tillDay, tillMonth, tillYear] = data.validTill.split('/')

                                        var fromDate = new Date(fromYear, fromMonth - 1, fromDay).toLocaleDateString('en-US');
                                        var toDate = new Date(tillYear, tillMonth - 1, tillDay).toLocaleDateString('en-US');

                                        var userImagesObj = {
                                            userId: data.userId,
                                            companyName: data.companyName,
                                            contactPerson: data.contactPerson,
                                            emailAddress: data.emailAddress,
                                            phoneNumber: data.phoneNumber,
                                            countryCode: data.countryCode,
                                            physicalAddress: data.physicalAddress,
                                            purposeOfAdvertisement: data.purposeOfAdvertisement,
                                            description: data.description,
                                            link: data.link,
                                            title: data.title,
                                            validFrom: fromDate,
                                            validTill: toDate,
                                            targetAudience: data.targetAudience,
                                            status: 'UNPAID'
                                            // caption: data.caption,

                                        }
                                        const s3 = new AWS.S3();
                                        // Binary data base64
                                        const fileContent = Buffer.from(postImagesAllImg.data, 'binary');
                                        var fileName = Date.now() + "." + ext;
                                        const params = {
                                            Bucket: 'griotlegacy',
                                            Key: fileName, // File name you want to save as in S3
                                            Body: fileContent
                                        };
                                        s3.upload(params, async function (err, dataRes) {
                                            if (err) {
                                                console.log({
                                                    err
                                                })
                                                CallBack()
                                            } else {
                                                console.log("IMAGES UPLOADED SUCCESSFULLY")
                                                userImagesObj.image = dataRes.Location;
                                                console.log('datares ', dataRes)
                                                if (["jpg", "jpeg", "bmp", "gif", "png", "x-png"].includes(ext)) {
                                                    // userImagesObj.type = 'IMAGE'
                                                    // userImagesObj.thumb = '';
                                                    userPostDocumentObjArr.push(userImagesObj);
                                                    CallBack()
                                                }

                                            }

                                            console.log({
                                                userPostDocumentObjArr
                                            })
                                        })
                                    }
                                }, async function (err, cont) {
                                    if (err) {
                                        callBack({
                                            success: false,
                                            STATUSCODE: 500,
                                            message: 'Something went wrong',
                                            response_data: {}
                                        });
                                    } else {
                                        await advertisementSchema.insertMany(userPostDocumentObjArr, async function (err, postDocresult) {
                                            if (err) {
                                                console.log({
                                                    err
                                                });
                                                callBack({
                                                    success: false,
                                                    STATUSCODE: 500,
                                                    message: 'Something went wrong',
                                                    response_data: {}
                                                });
                                            } else {
                                                if (postDocresult) {
                                                    console.log({
                                                        postDocresult
                                                    })
                                                    // await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'FILE' } });
                                                    callBack({
                                                        success: true,
                                                        STATUSCODE: 200,
                                                        message: 'Advertisement has been submitted successfully',
                                                        response_data: postDocresult
                                                    });
                                                }
                                            }
                                        });

                                    }
                                })
                            } else {
                                // await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

                                callBack({
                                    success: false,
                                    STATUSCODE: 400,
                                    message: 'Image requied',
                                    response_data: {}
                                });
                            }

                        } else {
                            // await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

                            callBack({
                                success: false,
                                STATUSCODE: 400,
                                message: 'Image required',
                                response_data: {}
                            });
                        }


                    } else {
                        callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: 'User not found',
                            response_data: {}
                        });
                    }
                }
            });

        }
    },
    getAdvertisement: (req, callBack) => {
        if (req) {
            var data = req.body;
            console.log(req.body, " req.body")
            if (!data.userId) {
                return callBack({
                    success: false,
                    STATUSCODE: 500,
                    message: 'user id required',
                    response_data: {}
                });
            } else {
                userSchema.findOne({ _id: data.userId }, async function (err, result) {
                    if (err) {
                        console.log('err', err);
                        callBack({
                            success: false,
                            STATUSCODE: 500,
                            message: 'Something went wrong',
                            response_data: {}
                        });
                    } else {
                        if (result) {
                            console.log(1)
                            var statusArr = ['PENDING', 'APPROVED', 'UNPAID', 'CANCELLED']
                            var adCount = await advertisementSchema.countDocuments({ userId: data.userId, status: { $in: statusArr } })
                            console.log("adCount === ", adCount, typeof (adCount))

                            advertisementSchema.find({ userId: data.userId }, (err, res) => {
                                if (err) {
                                    console.log(3)
                                    console.log('err', err);
                                    callBack({
                                        success: false,
                                        STATUSCODE: 500,
                                        message: 'Something went wrong',
                                        response_data: {}
                                    });
                                } else {
                                    console.log(4)
                                    callBack({
                                        success: true,
                                        STATUSCODE: 200,
                                        message: 'Advertisement list get successfully',
                                        advertisementCount: adCount,
                                        response_data: res
                                    });
                                }
                            })
                        } else {
                            console.log(5)
                            callBack({
                                success: false,
                                STATUSCODE: 422,
                                message: 'User not found',
                                response_data: {}
                            });
                        }
                    }
                })
            }

        }
    },
    deleteAd: async (data, callBack) => {
        if (data) {
            try {
                await advertisementSchema.deleteOne({ _id: data.advertisementId })
                    .then(result => {
                        console.log("<<delete>>>", result)
                        callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: "Advertisement deleted successfully",
                            response_data: result
                        })
                    })
                    .catch(err => {
                        console.log("<<<catch err callback>>>", err)
                        callBack({
                            success: false,
                            STATUSCODE: 400,
                            message: "Internal DB error",
                            response_data: {}
                        })
                    })
            } catch (err) {
                console.log("<<<err>>>", err)
                callBack({
                    success: false,
                    STATUSCODE: 400,
                    message: "Something went wrong",
                    response_data: {}
                })
            }
        } else {
            callBack({
                success: false,
                STATUSCODE: 202,
                message: "Please enter required data",
                response_data: {}
            })
        }
    },
    cancelAd: async (data, callBack) => {
        if (data) {
            try {
                await advertisementSchema.updateOne({ _id: data.advertisementId }, { status: 'CANCELLED' })
                    .then(result => {
                        console.log("<<Cancelled>>>", result)
                        callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: "Advertisement Cancelled successfully",
                            response_data: result
                        })
                    })
                    .catch(err => {
                        console.log("<<<catch err callback>>>", err)
                        callBack({
                            success: false,
                            STATUSCODE: 400,
                            message: "Internal DB error",
                            response_data: {}
                        })
                    })
            } catch (err) {
                console.log("<<<err>>>", err)
                callBack({
                    success: false,
                    STATUSCODE: 400,
                    message: "Something went wrong",
                    response_data: {}
                })
            }
        } else {
            callBack({
                success: false,
                STATUSCODE: 202,
                message: "Please enter required data",
                response_data: {}
            })
        }
    },

    editAdvertisement: async (data, callBack) => {
        try {
            console.log("data files :: ", data.files)
            if (data.files) {
                var postImages = data.files
                var imgFnd = 0
                if (Array.isArray(postImages.image) == true) {
                    var postImagesAllImgs = postImages.image
                    imgFnd++
                } else {
                    var postImagesAllImgs = [];
                    var postImagesAllImgsObj = postImages.image;
                    postImagesAllImgs.push(postImagesAllImgsObj);
                    imgFnd++;
                }
                // if (postImagesAllImgs.length > 0) {
                var userPostDocumentObjArr = [];
                var imgExErr = 0;
                var imgUp = 0;
                var postImgLength = postImagesAllImgs.length;
                _async.forEach(Object.keys(postImagesAllImgs), function (itemKey, CallBack) {
                    var postImagesAllImg = postImagesAllImgs[itemKey];
                    console.log("postImagesAllImgs", postImagesAllImgs)
                    var filename = postImagesAllImg.name;
                    var fileArr = filename.split(".");
                    if (fileArr.length == 2) {
                        var ext = fileArr[1];
                    } else if (fileArr.length == 3) {
                        var ext = fileArr[2];
                    } else {
                        var ext = fileArr[1];
                    }
                    if (!["JPG", "JPEG", "PNG", "jpg", "jpeg", "bmp", "gif", "png", "x-png", "avi", "flv", "wmv", "mp4", "mov", "MOV", "MP4"].includes(ext)) {
                        CallBack()
                    } else {
                        if (data.body.validFrom) {
                            var [fromDay, fromMonth, fromYear] = data.body.validFrom.split('/')
                            var fromDate = new Date(fromYear, fromMonth - 1, fromDay).toLocaleDateString('en-US');
                        }

                        if (data.body.validTill) {
                            var [tillDay, tillMonth, tillYear] = data.body.validTill.split('/')
                            var toDate = new Date(tillYear, tillMonth - 1, tillDay).toLocaleDateString('en-US');
                        }




                        // var fromDate = new Date(fromYear, fromMonth - 1, fromDay).toLocaleDateString('en-US');
                        // var toDate = new Date(tillYear, tillMonth - 1, tillDay).toLocaleDateString('en-US');
                        advertisementSchema.findOne({ _id: data.body.advertisementId })
                            .then(advertisementData => {

                                var userImagesObj = {
                                    companyName: data.body.companyName ? data.body.companyName : advertisementData.companyName,
                                    contactPerson: data.body.contactPerson ? data.body.contactPerson : advertisementData.contactPerson,
                                    emailAddress: data.body.emailAddress ? data.body.emailAddress : advertisementData.emailAddress,
                                    phoneNumber: data.body.phoneNumber ? data.body.phoneNumber : advertisementData.phoneNumber,
                                    countryCode: data.body.countryCode ? data.body.countryCode : advertisementData.countryCode,
                                    physicalAddress: data.body.physicalAddress ? data.body.physicalAddress : advertisementData.physicalAddress,
                                    purposeOfAdvertisement: data.body.purposeOfAdvertisement ? data.body.purposeOfAdvertisement : advertisementData.purposeOfAdvertisement,
                                    description: data.body.description ? data.body.description : advertisementData.description,
                                    link: data.body.link ? data.body.link : advertisementData.link,
                                    title: data.body.title ? data.body.title : advertisementData.title,
                                    validFrom: fromDate ? fromDate : advertisementData.validFrom,
                                    validTill: toDate ? toDate : advertisementData.validTill,
                                    targetAudience: data.body.targetAudience ? data.body.targetAudience : advertisementData.targetAudience,
                                    // caption: data.caption,
                                }
                                const s3 = new AWS.S3();
                                // Binary data base64
                                const fileContent = Buffer.from(postImagesAllImg.data, 'binary');
                                var fileName = Date.now() + "." + ext;
                                const params = {
                                    Bucket: 'griotlegacy',
                                    Key: fileName, // File name you want to save as in S3
                                    Body: fileContent
                                };
                                s3.upload(params, function (err, dataRes) {
                                    if (err) {
                                        CallBack()
                                    } else {
                                        userImagesObj.image = dataRes.Location;
                                        console.log('datares ', dataRes)
                                        // if (["jpg", "jpeg", "bmp", "gif", "png", "x-png"].includes(ext)) {
                                        // userImagesObj.type = 'IMAGE'
                                        // userImagesObj.thumb = '';
                                        userPostDocumentObjArr.push(userImagesObj);
                                        CallBack()
                                        // }

                                    }
                                })
                            })

                            .catch(err => {
                                console.log("ERR : ", err)
                            })

                    }
                }, function (err, cont) {
                    if (err) {
                        callBack({
                            success: false,
                            STATUSCODE: 500,
                            message: 'Something went wrong',
                            response_data: {}
                        });
                    } else {
                        advertisementSchema.insertMany(userPostDocumentObjArr, async function (err, postDocresult) {
                            if (err) {
                                console.log(err);
                                callBack({
                                    success: false,
                                    STATUSCODE: 500,
                                    message: 'Something went wrong',
                                    response_data: {}
                                });
                            } else {
                                if (postDocresult) {
                                    // await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'FILE' } });
                                    callBack({
                                        success: true,
                                        STATUSCODE: 200,
                                        message: 'Advertisement has been updated successfully',
                                        response_data: postDocresult
                                    });
                                }
                            }
                        });

                    }
                })
                // }
                // else {
                //     // await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

                //     callBack({
                //         success: false,
                //         STATUSCODE: 400,
                //         message: 'Image requied',
                //         response_data: {}
                //     });
                // }

            } else {
                var advertisementData = await advertisementSchema.findOne({ _id: data.body.advertisementId })
                if (data.body.validFrom) {
                    var [fromDay, fromMonth, fromYear] = data.body.validFrom.split('/')
                    var fromDate = new Date(fromYear, fromMonth - 1, fromDay).toLocaleDateString('en-US');
                }

                if (data.body.validTill) {
                    var [tillDay, tillMonth, tillYear] = data.body.validTill.split('/')
                    var toDate = new Date(tillYear, tillMonth - 1, tillDay).toLocaleDateString('en-US');
                }
                var adObj = {
                    companyName: data.body.companyName ? data.body.companyName : advertisementData.companyName,
                    contactPerson: data.body.contactPerson ? data.body.contactPerson : advertisementData.contactPerson,
                    emailAddress: data.body.emailAddress ? data.body.emailAddress : advertisementData.emailAddress,
                    phoneNumber: data.body.phoneNumber ? data.body.phoneNumber : advertisementData.phoneNumber,
                    countryCode: data.body.countryCode ? data.body.countryCode : advertisementData.countryCode,
                    physicalAddress: data.body.physicalAddress ? data.body.physicalAddress : advertisementData.physicalAddress,
                    purposeOfAdvertisement: data.body.purposeOfAdvertisement ? data.body.purposeOfAdvertisement : advertisementData.purposeOfAdvertisement,
                    description: data.body.description ? data.body.description : advertisementData.description,
                    link: data.body.link ? data.body.link : advertisementData.link,
                    title: data.body.title ? data.body.title : advertisementData.title,
                    validFrom: fromDate ? fromDate : advertisementData.validFrom,
                    validTill: toDate ? toDate : advertisementData.validTill,
                    targetAudience: data.body.targetAudience ? data.body.targetAudience : advertisementData.targetAudience,
                    // caption: data.caption,
                }
                await advertisementSchema.updateOne({ _id: data.body.advertisementId }, adObj)
                    .then(async result => {
                        var updatedAd = await advertisementSchema.find({ _id: data.body.advertisementId })
                        callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: "Advertisement updated successfully",
                            response_data: updatedAd
                        })
                        return
                    })

                    .catch(err => {
                        console.log("ERR: ", err)
                        callBack({
                            success: false,
                            STATUSCODE: 400,
                            message: "Error updating advertisement",
                            response_data: {}
                        })
                        return
                    })
            }
        } catch (err) {
            console.log("Err: ", err)
            callBack({
                success: false,
                STATUSCODE: 202,
                message: "Please enter required data",
                response_data: {}
            })
        }
    },
    updatePost: (req, callBack) => {
        if (req) {
            var data = req.body;
            console.log(req.body, " req.body")
            var postImages = req.files;
            console.log('--------files--------------', postImages);

            userSchema.findOne({ _id: data.userId }, async function (err, result) {
                if (err) {
                    console.log('err', err);
                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Something went wrong',
                        response_data: {}
                    });
                } else {
                    if (result) {

                        var tribeIdArr = (data.tribeId).split(",");

                        var userPostObj = {
                            userId: result._id,
                            caption: data.caption,
                            postType: data.postType,
                            audience: data.audience,
                            tribe: tribeIdArr
                        }


                        userPostSchema.updateOne({ _id: data.postId }, { $set: userPostObj }, async function (err, userPost) {
                            if (err) {
                                console.log(err);
                                callBack({
                                    success: false,
                                    STATUSCODE: 500,
                                    message: 'Something went wrong',
                                    response_data: {}
                                });
                            } else {

                                var oldFileIdsArray = [];
                                var oldFileIds = data.fileIds;

                                if ((oldFileIds != undefined) && (oldFileIds != '')) {
                                    oldFileIdsArray = oldFileIds.split(",");
                                }

                                console.log('oldFileIdsArray', oldFileIdsArray);
                                // console.log('data.postId', data.postId);
                                let i = 0;
                                if (oldFileIdsArray.length > 0) {

                                    for (let oldf of oldFileIdsArray) {
                                        var updateFile = await userFileSchema.updateOne({ _id: oldf }, { $set: { arrange: i } });
                                        console.log('updateFile', i, updateFile);
                                        i++;
                                    }
                                    var userFileDatas = await userFileSchema.find({ postId: data.postId, _id: { $nin: oldFileIdsArray } });

                                    console.log('userFileDatas', userFileDatas);

                                    if (userFileDatas.length > 0) {

                                        for (let userFl of userFileDatas) {

                                            var getres = await userFileSchema.deleteOne({ _id: userFl._id });

                                            // console.log('getres', getres);

                                            if (userFl.file != '') {
                                                var fs = require('fs');
                                                var filePath = `${userFl.file}`;
                                                fs.unlink(filePath, (err) => {
                                                    console.log('err', err);
                                                });
                                                var filePathThumb = `${userFl.thumb}`;
                                                fs.unlink(filePathThumb, (errThumb) => {
                                                    console.log('errThumb', errThumb);
                                                });
                                            }
                                        }

                                    }
                                }
                                if (postImages != null) {
                                    const userFolder = `${result._id}/`
                                    var imgFnd = 0;
                                    // console.log("postImages.name", postImages.image)
                                    if (Array.isArray(postImages.image) == true) {
                                        console.log('Array');
                                        var postImagesAllImgs = postImages.image;
                                        imgFnd++;
                                    } else {
                                        console.log('Object');
                                        var postImagesAllImgs = [];
                                        var postImagesAllImgsObj = postImages.image;
                                        postImagesAllImgs.push(postImagesAllImgsObj);
                                        imgFnd++;
                                    }

                                    console.log('------------postImagesAllImgs--------------', postImagesAllImgs);
                                    if (postImagesAllImgs.length > 0) {
                                        var userPostDocumentObjArr = [];
                                        var imgExErr = 0;
                                        var imgUp = 0;
                                        var postImgLength = postImagesAllImgs.length;

                                        console.log(postImgLength)

                                        var count = oldFileIdsArray.length

                                        _async.forEach(Object.keys(postImagesAllImgs), function (itemKey, CallBack) {
                                            console.log("item key 1234 ===== ", count)
                                            console.log("postImagesAllImgs[itemKey] ==== ", postImagesAllImgs[itemKey])
                                            var postImagesAllImg = postImagesAllImgs[itemKey];
                                            var filename = postImagesAllImg.name;
                                            var fileArr = filename.split(".");
                                            if (fileArr.length == 2) {
                                                var ext = fileArr[1];
                                            } else if (fileArr.length == 3) {
                                                var ext = fileArr[2];
                                            } else {
                                                var ext = fileArr[1];
                                            }

                                            if (!["JPG", "JPEG", "PNG", "jpg", "jpeg", "bmp", "gif", "png", "x-png", "avi", "flv", "wmv", "mp4", "mov", "MOV", "MP4"].includes(ext)) {
                                                CallBack()
                                            } else {
                                                var userImagesObj = {
                                                    userId: result._id,
                                                    postId: data.postId,
                                                    album: data.album,
                                                    caption: data.caption,
                                                    arrange: count
                                                }
                                                count++

                                                // console.log("userImagesObj", userImagesObj)
                                                const s3 = new AWS.S3();
                                                // binary data base64
                                                const fileContent = Buffer.from(postImagesAllImg.data, 'binary');

                                                var fileName = Date.now() + "." + ext;
                                                const params = {
                                                    Bucket: 'griotlegacy',
                                                    Key: `${userFolder}${fileName}`,
                                                    Body: fileContent
                                                };
                                                s3.upload(params, function (err, dataRes) {
                                                    console.log('dataRes ', dataRes)
                                                    if (err) {
                                                        CallBack()
                                                    } else {
                                                        userImagesObj.file = dataRes.Location;
                                                        if (["jpg", "jpeg", "bmp", "gif", "png", "x-png"].includes(ext)) {
                                                            userImagesObj.type = 'IMAGE'
                                                            userImagesObj.thumb = '';
                                                            userPostDocumentObjArr.push(userImagesObj);
                                                            CallBack()
                                                        } else {
                                                            const s3 = new AWS.S3();
                                                            var thumbImagesAllImg = req.files.thumb;
                                                            const thumbImage = Array.isArray(thumbImagesAllImg) ? thumbImagesAllImg[itemKey] : thumbImagesAllImg
                                                            if (thumbImage) {
                                                                const thumbFileContent = Buffer.from(thumbImage.data, 'binary')
                                                                var thumbExt = thumbImage.name.slice(thumbImage.data.lastIndexOf('.'))
                                                                var thumbFileName = Date.now() + thumbExt

                                                                const thumbParams = {
                                                                    Bucket: 'griotlegacy',
                                                                    Key: `${userFolder}${thumbFileName}`,
                                                                    Body: thumbFileContent
                                                                }

                                                                s3.upload(thumbParams, function (errThumb, dataResThumb) {
                                                                    if (errThumb) {
                                                                        userImagesObj.type = 'VIDEO'
                                                                        userImagesObj.thumb = ''
                                                                    } else {
                                                                        userImagesObj.type = 'VIDEO'
                                                                        userImagesObj.thumb = dataResThumb.Location
                                                                    }

                                                                    userPostDocumentObjArr.push(userImagesObj)
                                                                    CallBack()
                                                                })
                                                            } else {
                                                                userImagesObj.type = 'VIDEO'
                                                                userImagesObj.thumb = ''
                                                                userPostDocumentObjArr.push(userImagesObj)
                                                                CallBack()
                                                            }
                                                        }
                                                    }
                                                })
                                            }
                                        }, async function (err, cont) {
                                            if (err) {
                                                console.log("err", err)
                                                callBack({
                                                    success: false,
                                                    STATUSCODE: 500,
                                                    message: 'Something went wrong',
                                                    response_data: {}
                                                });
                                            } else {
                                                userFileSchema.insertMany(userPostDocumentObjArr, async function (err, postDocresult) {
                                                    if (err) {
                                                        console.log("err", err);
                                                        callBack({
                                                            success: false,
                                                            STATUSCODE: 500,
                                                            message: 'Something went wrong',
                                                            response_data: {}
                                                        })
                                                    } else {
                                                        if (postDocresult) {
                                                            await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'FILE' } });
                                                            callBack({
                                                                success: true,
                                                                STATUSCODE: 200,
                                                                message: 'Post Added Successfully',
                                                                response_data: {}
                                                            })
                                                        }
                                                    }
                                                });

                                            }
                                        })
                                        //here
                                    } else {
                                        await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

                                        callBack({
                                            success: true,
                                            STATUSCODE: 200,
                                            message: 'Post added successfully',
                                            response_data: {}
                                        })
                                    }
                                } else {
                                    await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

                                    callBack({
                                        success: true,
                                        STATUSCODE: 200,
                                        message: 'Post uploaded successfully',
                                        response_data: {}
                                    });
                                }

                            }
                        });


                    } else {
                        callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: 'User not found',
                            response_data: {}
                        });
                    }
                }
            });

        }
    },

    home: async (req, callBack) => {
        if (req) {
            var data = req.body;
            // console.log('data', data);
            // return;
            var postIdArr = []

            // await userPostSchema.find({ userId: data.userId })
            //     .then(async (posts) => {
            //         if (posts.length > 0) {
            //             for (let post of posts) {
            //                 postIdArr.push(post._id)
            //             }
            //         }
            //     })

            // console.log("arrrrr====", postIdArr)

            userFileSchema
                .aggregate(
                    [
                        {
                            "$match":
                                { userId: data.userId }
                        },
                        {
                            "$group": {
                                "_id": { name: "$album" }
                            }
                        }
                    ])
                .sort({ arrange: 'asc' })

                .then(async (albumNames) => {
                    var responseData = {};
                    var fileArr = [];
                    // console.log('albumNames', albumNames);
                    if (albumNames.length > 0) {
                        for (let albNm of albumNames) {
                            var fileObj = {};
                            var albNmU = albNm._id.name;
                            // console.log('albNmU', albNmU);
                            fileObj['album'] = albNmU;
                            var fetAlbmData = await userFileSchema.find({ album: albNmU }).sort({ arrange: 'asc' });
                            fileObj['data'] = fetAlbmData;

                            // for(let i = 0; i<fileObj['data'].length; i++ ){
                            //     if(fileObj['data'][i].file.startsWith('post')){
                            //         fileObj['data'][i].file = `${config.fileUrl}post/`+fileObj['data'][i].file
                            //         // console.log("starts With === ", fileObj['data'][i])
                            //     } else {
                            //         console.log("else part === ", fileObj['data'][i])
                            //     }
                            // }

                            //GetComment, Like
                            var getPostId = fetAlbmData[0].postId;


                            //GetPostLike
                            var userPostData = await userPostSchema.findOne({ _id: getPostId });
                            fileObj['post'] = userPostData

                            //GetPostLike
                            fileObj['like'] = await LikeSchema.find({ postId: getPostId }).populate([
                                {
                                    path: "likedBy",
                                    select: "userName fullName email profileImage",
                                    model: "User",
                                },
                            ])

                            //Get Post Comment
                            fileObj['comment'] = await CommentSchema.find({ postId: getPostId }).populate([
                                {
                                    path: "commentedBy",
                                    select: "userName fullName email profileImage",
                                    model: "User",
                                },
                            ])

                            // var isBlocked = await userPostSchema.findOne({_id: getPostId}).select('isBlocked -_id')
                            // fileObj['isBlocked'] = isBlocked.isBlocked
                            // console.log("this is isBlocked::::::", isBlocked)

                            // if(fileObj.post == null || fileObj.post == )
                            fileArr.push(fileObj);
                        }



                        var fetchUser = await userSchema.findOne({ _id: data.userId });




                        responseData.user = fetchUser;
                        responseData.dashboard = fileArr;
                        responseData.user = fetchUser;
                        responseData.userPic = `${config.serverhost}:${config.port}/img/profile-pic/`;
                        responseData.postPic = `${config.serverhost}:${config.port}/img/post/`;
                    }

                    //GET TRIBE USER
                    var getTribe = await mapUserTribeSchema.find({ userId: data.userId });
                    var userFlsArr = [];
                    if (getTribe.length > 0) {
                        for (let tribeMap of getTribe) {
                            var tribeId = tribeMap.tribeId;

                            var fetchPostTribe = await userPostSchema.find({ tribe: { $in: tribeId }, userId: { $ne: data.userId }, isBlocked: { $ne: true }, postType: 'FILE', createdAt: { "$gt": new Date(Date.now() - 24 * 60 * 60 * 1000) } });

                            //   var fetchPostTribe = await userPostSchema.find({tribe : {$in:tribeId}, postType: 'FILE' });

                            console.log(fetchPostTribe.length);

                            if (fetchPostTribe.length > 0) {
                                for (let userPst of fetchPostTribe) {
                                    var userFlS = await userFileSchema.findOne({ postId: (userPst._id).toString() });
                                    if (userFlS != null) {
                                        var userTrPst = await userSchema.findOne({ _id: userFlS.userId });
                                        userFlsArr.push({ post: userFlS, user: userTrPst });
                                    }


                                }
                            }

                        }
                    }

                    //GET INNER CIRCLE
                    var getIc = await mapUserInnerCircleSchema.find({ userId: data.userId });

                    if (getIc.length > 0) {
                        for (let icMap of getIc) {
                            var circleId = icMap.circleUserId;

                            var fetchIc = await userPostSchema.find({ userId: circleId, isBlocked: { $ne: true }, postType: 'FILE', createdAt: { "$gt": new Date(Date.now() - 24 * 60 * 60 * 1000) } });

                            //   var fetchPostTribe = await userPostSchema.find({tribe : {$in:tribeId}, postType: 'FILE' });

                            console.log(fetchIc.length);

                            if (fetchIc.length > 0) {
                                for (let usrIc of fetchIc) {
                                    var userUls = await userFileSchema.findOne({ postId: (usrIc._id).toString() });
                                    if (userUls != null) {
                                        var userTrPst = await userSchema.findOne({ _id: userUls.userId });
                                        userFlsArr.push({ post: userUls, user: userTrPst });
                                    }


                                }
                            }

                        }
                    }

                    console.log('userFlsArr', userFlsArr.length);
                    responseData.trending = userFlsArr;
                    // console.log('responseData',getTribe);

                    callBack({
                        success: true,
                        STATUSCODE: 200,
                        message: 'Dashboard data',
                        response_data: responseData
                    });
                })
                .catch((err) => {
                    console.log('err', err);

                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Something went wrong',
                        response_data: {}
                    });
                })
            // { userId: data.userId }, async function (err, files) {
            // if (err) {
            //     console.log('err', err);
            //     callBack({
            //         success: false,
            //         STATUSCODE: 500,
            //         message: 'Something went wrong',
            //         response_data: {}
            //     });
            // } else {
            //     if (files) {
            //       //  console.log('files',files);
            //         // return;



            //         var filesArr = [];
            //         var albumArr = [];
            //         if(files.length > 0) {
            //             for(let file of files) {
            //                 var filesObj = {};

            //                 if(!albumArr.includes(file.album)) {
            //                     albumArr.push(file.album);
            //                     filesObj[file.album] = [file];
            //                 } else {
            //                     console.log('file',filesObj);
            //                     filesObj[file.album] = [];
            //                     filesObj[file.album].push(file);
            //                 }



            //                     // filesObj['file'] = file

            //                     filesArr.push(filesObj);
            //             }
            //         }

            //         console.log('filesArr',filesArr);




            //     } else {
            //         callBack({
            //             success: false,
            //             STATUSCODE: 422,
            //             message: 'User not found',
            //             response_data: {}
            //         });
            //     }
            // }
            // });

        }
    },

    removePost: (req, callBack) => {
        if (req) {
            var data = req.body;
            var userId = data.userId;
            var postId = data.postId;

            userPostSchema.findOne({ _id: postId, userId: userId })
                .then(async (userPost) => {

                    if (userPost != null) {
                        userPostSchema.deleteOne({ _id: (postId).toString() }, function (err) {
                            if (err) {
                                console.log(err);
                            }
                            // deleted at most one tank document
                        });

                        var userFileDatas = await userFileSchema.find({ postId: postId });

                        if (userFileDatas.length > 0) {

                            userFileSchema.deleteMany({ postId: postId }).then(function () {
                                console.log("Data deleted"); // Success


                            }).catch(function (error) {
                                console.log(error); // Failure
                            });
                            for (let userFl of userFileDatas) {

                                if (userFl.file != '') {
                                    var fs = require('fs');
                                    var filePath = `public/img/post/${userFl.file}`;
                                    fs.unlink(filePath, (err) => { });
                                    var filePathThumb = `public/img/post/${userFl.thumb}`;
                                    fs.unlink(filePathThumb, (errThumb) => { });
                                }
                            }

                        }



                        callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: 'Post deleted successfully',
                            response_data: {}
                        });
                    } else {

                        callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: 'Something went wrong',
                            response_data: {}
                        });
                    }

                })
                .catch((err) => {
                    console.log('err', err);
                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Something went wrong',
                        response_data: {}
                    });
                })





        }
    },
    removeImage: (req, callBack) => {
        if (req) {
            var data = req.body;
            var userId = data.userId;
            var imageId = data.imageId;

            userFileSchema.findOne({ _id: imageId })
                .then(async (userFl) => {
                    console.log('userFl', userFl);
                    if (userFl != null) {


                        userFileSchema.deleteOne({ _id: imageId }).then(function () {
                            var fs = require('fs');
                            var filePath = `public/img/post/${userFl.file}`;
                            fs.unlink(filePath, (err) => { });
                            var filePathThumb = `public/img/post/${userFl.thumb}`;
                            fs.unlink(filePathThumb, (errThumb) => { });


                        }).catch(function (error) {
                            console.log(error); // Failure
                        });




                        callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: 'Image deleted successfully',
                            response_data: {}
                        });
                    } else {

                        callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: 'Something went wrong',
                            response_data: {}
                        });
                    }

                })
                .catch((err) => {
                    console.log('err', err);
                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Something went wrong',
                        response_data: {}
                    });
                })





        }
    },
    likePost: (req, callBack) => {
        if (req) {
            var data = req.body;
            var userId = data.userId;
            var postId = data.postId;

            userPostSchema.findOne({ _id: postId, isBlocked: false })
                .then(async (userPost) => {

                    if (userPost != null) {
                        const checkPostAlreadyLiked = await LikeSchema.find({
                            postId: postId,
                            likedBy: userId,
                        });
                        console.log(checkPostAlreadyLiked);
                        if (checkPostAlreadyLiked.length !== 0) {
                            callBack({
                                success: false,
                                STATUSCODE: 422,
                                message: 'Post Already Liked',
                                response_data: {}
                            });
                        } else {
                            const postData = {
                                postId: postId,
                                likedBy: userId,
                            };
                            const newLike = LikeSchema(postData);
                            const savelike = await newLike.save();
                            await userPostSchema.findOneAndUpdate(
                                { _id: postId },
                                {
                                    $push: {
                                        likes: savelike._id,
                                    },
                                }
                            );


                            var likedUser = await userSchema.findOne({ _id: userId.toString() });
                            var message = `${likedUser.fullName} liked your post`;

                            if (userPost.userId.toString() != userId.toString()) {
                                addNotificationDataDB(userPost.userId, 'POST_LIKE', message, postId, userId)
                            }
                            callBack({
                                success: true,
                                STATUSCODE: 200,
                                message: 'Post Liked Successfully',
                                response_data: savelike
                            });
                        }
                    } else {

                        callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: 'Something went wrong',
                            response_data: {}
                        });
                    }

                })
                .catch((err) => {
                    console.log('err', err);
                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Something went wrong',
                        response_data: {}
                    });
                })





        }
    },
    unlikePost: (req, callBack) => {
        if (req) {
            var data = req.body;
            var userId = data.userId;
            var postId = data.postId;

            userPostSchema.findOne({ _id: postId, isBlocked: false })
                .then(async (userPost) => {

                    if (userPost != null) {

                        const checkPostAlreadyLiked = await LikeSchema.find({
                            postId: postId,
                            likedBy: userId,
                        });
                        console.log(checkPostAlreadyLiked);
                        if (checkPostAlreadyLiked.length !== 0) {
                            const postData = {
                                postId: postId,
                                likedBy: userId,
                            };
                            await LikeSchema.findByIdAndDelete(checkPostAlreadyLiked[0]._id);
                            await userPostSchema.findOneAndUpdate(
                                { _id: postId },
                                {
                                    $pull: {
                                        likes: checkPostAlreadyLiked[0]._id,
                                    },
                                }
                            );

                            callBack({
                                success: true,
                                STATUSCODE: 200,
                                message: 'Post UnLiked successfully',
                                response_data: {}
                            });
                        } else {

                            callBack({
                                success: false,
                                STATUSCODE: 422,
                                message: 'Post Not yet Liked',
                                response_data: {}
                            });
                        }
                    } else {

                        callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: 'Something went wrong',
                            response_data: {}
                        });
                    }

                })
                .catch((err) => {
                    console.log('err', err);
                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Something went wrong',
                        response_data: {}
                    });
                })





        }
    },
    commentPost: (req, callBack) => {
        if (req) {
            var data = req.body;
            var userId = data.userId;
            var postId = data.postId;

            userPostSchema.findOne({ _id: postId })
                .then(async (userPost) => {
                    console.log("userPost", userPost)
                    if (userPost != null) {

                        const postData = {
                            postId: postId,
                            comment: req.body.comment,
                            commentedBy: userId
                        };
                        const newComment = CommentSchema(postData);
                        const savedCommentObj = await newComment.save();

                        await userPostSchema.findOneAndUpdate(
                            { _id: postId },
                            {
                                $push: {
                                    comments: savedCommentObj._id,
                                },
                            }
                        );


                        //Notification End

                        var commentedUser = await userSchema.findOne({ _id: userId.toString() });

                        console.log("fullname", commentedUser.fullName)

                        if (commentedUser.profileImage == '' || commentedUser.profileImage == null || commentedUser.profileImage == undefined) {
                            var profileImage = ''
                        } else {
                            var profileImage = commentedUser.profileImage
                        }

                        if (commentedUser.fullName == '' || commentedUser.fullName == null || commentedUser.fullName == undefined) {
                            var fullName = ''
                        } else {
                            var fullName = commentedUser.fullName
                        }

                        var savedComment = {
                            created_At: savedCommentObj.created_At,
                            _id: savedCommentObj._id,
                            postId: savedCommentObj.postId,
                            comment: savedCommentObj.comment,
                            commentedBy: savedCommentObj.commentedBy,
                            fullName: fullName,
                            image: profileImage,
                            createdAt: savedCommentObj.createdAt,
                            updatedAt: savedCommentObj.updatedAt

                        }

                        var message = `${commentedUser.fullName} commented on your post`;

                        if (userPost.userId.toString() != userId.toString()) {
                            addNotificationDataDB(userPost.userId, 'POST_COMMENT', message, postId, userId);
                        }

                        callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: 'Comment Added Successfully',
                            response_data: savedComment
                        });
                    } else {

                        callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: 'Something went wrong',
                            response_data: {}
                        });
                    }

                })
                .catch((err) => {
                    console.log('err', err);
                    callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: 'Something went wrong',
                        response_data: {}
                    });
                })





        }
    },
    dashboard: async (req, callBack) => {
        if (req) {
            var data = req.body;
            let responseDataArray = [];
            let advertisementListArray = [];

            var advertisementList = await advertisementSchema.find({ "validTill": { $gte: new Date().toISOString() }, "status": "APPROVED" });
            console.log("<<ad>>", advertisementList)
            for (let advertisement of advertisementList) {
                var advertisementObj = {};
                advertisementObj.postType = "advertisement";
                advertisementObj.image = advertisement.image;
                advertisementObj.link = advertisement.link;
                advertisementObj.title = advertisement.title;
                advertisementObj._id = advertisement._id;
                advertisementObj.imageKey = advertisement.image;
                advertisementObj.validFrom = advertisement.validFrom;
                advertisementObj.validTill = advertisement.validTill;
                // advertisementObj.trimmedValidFrom = advertisement.trimmedValidFrom;
                // advertisementObj.trimmedValidTill = advertisement.trimmedValidTill;

                advertisementListArray.push(advertisementObj);
            }
            console.log("advertisement list array===", advertisementListArray)
            advertisementObj = advertisementListArray



            var checkVillagePost = await userPostSchema.find({ audience: "VILLAGE", isBlocked: false });
            //console.log("checkVillagePost",checkVillagePost);return;
            // for(let i = 0 ; i<= checkVillagePost.length -1 ; i++){
            _async.forEach(Object.keys(checkVillagePost), function (itemKey, CallBack) {
                var checkVillage = checkVillagePost[itemKey];
                userFileSchema
                    .aggregate(
                        [
                            { "$match": { postId: checkVillage._id.toString() } },
                            {
                                "$group": {
                                    "_id": { name: "$album", postId: "$postId" }
                                }

                            },
                        ])
                    .sort({ arrange: 'asc' })

                    .then(async (albumNames) => {
                        // console.log("albumNames",albumNames);return;
                        var fileArr = [];
                        var responseData = {};
                        // console.log('albumNames', albumNames);
                        if (albumNames.length > 0) {

                            for (let albNm of albumNames) {
                                // userPostSchema
                                // .aggregate(
                                //     [
                                //      { "$match": { _id:ObjectId(albNm._id.postId) } },

                                //     ]).then(async (postData) => {
                                //         console.log("postData",postData);return;
                                //     }).catch(

                                //     )
                                var fileObj = {};
                                var albNmU = albNm._id.name;
                                //console.log('albNm', albNm);
                                fileObj['album'] = albNmU;
                                fileObj['postType'] = "album";
                                var fetAlbmData = await userFileSchema.find({ album: albNmU }).sort({ arrange: 'asc' });
                                fileObj['data'] = fetAlbmData;

                                for (let i = 0; i < fileObj['data'].length; i++) {
                                    if (fileObj['data'][i].file.startsWith('post')) {
                                        fileObj['data'][i].file = `${config.fileUrl}post/` + fileObj['data'][i].file
                                        // console.log("starts With === ", fileObj['data'][i])
                                    } else {
                                        console.log("else part === ", fileObj['data'][i])
                                    }
                                }
                                // console.log("album data === ", fetAlbmData)

                                //GetComment, Like
                                var getPostId = fetAlbmData[0].postId;


                                //GetPostLike
                                var userPostData = await userPostSchema.findOne({ _id: getPostId, isBlocked: false });
                                fileObj['post'] = userPostData

                                //GetPostLike
                                fileObj['like'] = await LikeSchema.find({ postId: getPostId }).populate([
                                    {
                                        path: "likedBy",
                                        select: "userName fullName email profileImage",
                                        model: "User",
                                    },
                                ])

                                //Get Post Comment
                                fileObj['comment'] = await CommentSchema.find({ postId: getPostId }).populate([
                                    {
                                        path: "commentedBy",
                                        select: "userName fullName email profileImage",
                                        model: "User",
                                    },
                                ])

                                var isBlocked = await userPostSchema.findOne({ _id: getPostId }).select('isBlocked -_id')
                                fileObj['isBlocked'] = isBlocked.isBlocked

                                fileObj['user'] = await userSchema.findOne({ _id: fetAlbmData[0].userId });
                                console.log("ID === ", fetAlbmData[0].userId)
                                // console.log("user===",fileObj['user'])
                                fileArr.push(fileObj);
                            }



                            // responseData.user = fetchUser;
                            responseData.dashboard = fileArr;
                            // responseData.user = fetchUser;
                            responseData.userPic = `${config.serverhost}:${config.port}/img/profile-pic/`;
                            responseData.postPic = `${config.serverhost}:${config.port}/img/post/`;
                        }

                        //GET TRIBE USER
                        var getTribe = await mapUserTribeSchema.find({ userId: data.userId });
                        var userFlsArr = [];
                        if (getTribe.length > 0) {
                            for (let tribeMap of getTribe) {
                                var tribeId = tribeMap.tribeId;

                                var fetchPostTribe = await userPostSchema.find({ tribe: { $in: tribeId }, isBlocked: false, userId: { $ne: data.userId }, postType: 'FILE', createdAt: { "$gt": new Date(Date.now() - 24 * 60 * 60 * 1000) } });

                                //   var fetchPostTribe = await userPostSchema.find({tribe : {$in:tribeId}, postType: 'FILE' });

                                // console.log(fetchPostTribe.length);

                                if (fetchPostTribe.length > 0) {
                                    for (let userPst of fetchPostTribe) {
                                        var userFlS = await userFileSchema.findOne({ postId: (userPst._id).toString() });
                                        if (userFlS != null) {
                                            var userTrPst = await userSchema.findOne({ _id: userFlS.userId });
                                            userFlsArr.push({ post: userFlS, user: userTrPst });
                                        }


                                    }
                                }

                            }
                        }

                        //GET INNER CIRCLE
                        var getIc = await mapUserInnerCircleSchema.find({ userId: data.userId });

                        if (getIc.length > 0) {
                            for (let icMap of getIc) {
                                var circleId = icMap.circleUserId;

                                var fetchIc = await userPostSchema.find({ userId: circleId, isBlocked: false, postType: 'FILE', createdAt: { "$gt": new Date(Date.now() - 24 * 60 * 60 * 1000) } });

                                //   var fetchPostTribe = await userPostSchema.find({tribe : {$in:tribeId}, postType: 'FILE' });

                                console.log(fetchIc.length);

                                if (fetchIc.length > 0) {
                                    for (let usrIc of fetchIc) {
                                        var userUls = await userFileSchema.findOne({ postId: (usrIc._id).toString() });
                                        if (userUls != null) {
                                            var userTrPst = await userSchema.findOne({ _id: userUls.userId });
                                            userFlsArr.push({ post: userUls, user: userTrPst });
                                        }


                                    }
                                }

                            }
                        }

                        // console.log('userFlsArr', userFlsArr.length);
                        responseData.trending = userFlsArr;

                        responseDataArray.push(responseData.dashboard[0]);
                        //console.log('responseData',responseData);
                        CallBack();
                        //  console.log('responseDataArray1',responseDataArray);

                        // callBack({
                        //     success: true,
                        //     STATUSCODE: 200,
                        //     message: 'Dashboard data',
                        //     response_data: responseData
                        // });
                    })
                    .catch((err) => {
                        console.log('err', err);

                        CallBack();
                    })
            }, function (err, con) {
                callBack({
                    success: true,
                    STATUSCODE: 200,
                    message: 'Dashboard data',
                    response_data: responseDataArray, advertisementListArray
                });
            })
            //for(let checkVillage of checkVillagePost){
            // console.log("checkVillage._id",checkVillage._id.toString());


            //  }
            // console.log('responseDataArray2',responseDataArray);
            // callBack({
            //     success: true,
            //     STATUSCODE: 200,
            //     message: 'Dashboard data',
            //     response_data: responseDataArray
            // });
        }
    }
}


function getExtension(filename) {
    console.log('filename', filename);
    return filename.substring(filename.indexOf('.') + 1);
}

function sendPushNotification(receiverId, notificationObj) {
    var gcm = require('node-gcm');
    var pushMessage = notificationObj.message;
    var badgeCount = 0;
    userDeviceLoginSchema
        .find({ userId: receiverId })
        .then(function (customers) {
            // console.log('customers',customers);
            var regTokens = [];
            if (customers.length > 0) {
                for (let customer of customers) {

                    var deviceToken = customer.deviceToken;


                    //ANDROID PUSH START
                    var andPushData = {
                        'badge': badgeCount,
                        'alert': pushMessage,
                        'deviceToken': deviceToken,
                        'dataset': notificationObj
                    }

                    console.log('andPushData', andPushData);



                    // Set up the sender with your GCM/FCM API key (declare this once for multiple messages)
                    var sender = new gcm.Sender(config.pushAPIKey);

                    // Prepare a message to be sent
                    var message = new gcm.Message({
                        data: {
                            sound: 'default',
                            alert: andPushData.dataset,
                            message: andPushData.alert,
                            click_action: 'FLUTTER_NOTIFICATION_CLICK'
                        },
                        notification: {
                            title: "Griot legacy",
                            icon: "ic_launcher",
                            body: pushMessage
                        }
                    });

                    // var message = new gcm.Message({
                    //   notification: {
                    //     title: 'New Puppy!',
                    //     body: `Puppy is ready for adoption`,
                    //     icon: 'your-icon-url',
                    //     tag: 'puppy', 
                    //     data: {}, 
                    //     click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
                    //   }
                    // });

                    // Specify which registration IDs to deliver the message to
                    //  console.log('length',andPushData.deviceToken.length);
                    if (andPushData.deviceToken.length > 10) {
                        regTokens.push(andPushData.deviceToken);
                    }
                    // Actually send the message

                    //ANDROID PUSH END




                }
            }

            console.log('regTokens', regTokens);
            console.log('message', message);
            sender.send(message, { registrationTokens: regTokens }, function (err, response) {
                if (err) {
                    //   console.error(err);

                    console.log('Push Err', err)
                } else {
                    console.log('Push Resp', response)
                };
            });

        })
}


async function addNotificationDataDB(userId, notificationType, message, otherData, otherUserId) {

    //Check Settings
    var notSettings = await checkNotificationSettings(userId);



    var notificationObj = {
        userId: userId,
        notificationType: notificationType,
        title: '',
        message: message,
        isRead: 'NO',
        otherData: otherData,
        otherUserId: otherUserId
    }

    console.log('notSettings', notSettings);
    if (notSettings == true) {
        var getCount = await userSchema.findOne({ _id: userId.toString() });

        console.log('getCount', getCount);
        var newNotCount = (Number(getCount.notificationCount) + 1);
        var pushNotObj = {
            userId: notificationObj.userId,
            notificationType: notificationObj.notificationType,
            message: notificationObj.message,
            isRead: notificationObj.isRead,
            otherData: notificationObj.otherData,
            otherUserId: notificationObj.otherUserId,
            count: newNotCount
        }

        await userSchema.updateOne({ _id: userId.toString() }, {
            $set: { notificationCount: newNotCount }
        });

        sendPushNotification(userId, pushNotObj);
    }


    new userNotificationSchema(notificationObj).save(async function (err, notification) {
        if (err) {
            console.log('Notification error', err);
        } else {
            console.log('Notification Saved');
        }
    })

}

function checkNotificationSettings(userId) {
    return new Promise(function (resolve, reject) {

        userSchema.findOne({ _id: userId })
            .then(async (notSetting) => {
                // console.log('notSetting',notSetting);
                if (notSetting != null) {


                    if (notSetting.notification == 'ON') {
                        return resolve(true);
                    } else {
                        return resolve(false);
                    }



                } else {
                    return resolve(true);
                }

            })
            .catch((error) => {
                return resolve(false);
            })

    });
}

// Function to upload a file to S3
async function uploadFileToS3(s3, folderPath, postImage) {
    var returnObj = {}
    console.log("inside upload function")
    var fileArr = postImage.name.split('.')
    var imageName = Date.now() + '.' + fileArr[1]
    const fileName = `${folderPath}${imageName}`;
    const fileContent = Buffer.from(postImage.data, 'binary');

    try {
        var uploadParams = {
            Bucket: 'griotlegacy',
            Key: fileName,
            Body: fileContent
        }
        var s3Upload = await s3.upload(uploadParams).promise();
        returnObj.file = s3Upload.Location



        return returnObj
    } catch (error) {
        console.error('Error uploading file to S3:', error);
        throw error;
    }
}
