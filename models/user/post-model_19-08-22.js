
var userSchema = require('../../schema/User');
var userPostSchema = require('../../schema/UserPost');
var userFileSchema = require('../../schema/UserFile');
var mapUserTribeSchema = require('../../schema/MapUserTribe');
var mapUserInnerCircleSchema = require('../../schema/MapUserInnerCircle');
var tribeSchema = require('../../schema/Tribe');
var LikeSchema = require('../../schema/Like');
var CommentSchema = require('../../schema/Comment');
var userNotificationSchema = require('../../schema/UserNotification');
var userDeviceLoginSchema = require('../../schema/UserDeviceLogin');
const config = require('../../config');


module.exports = {
    createPost: (req, callBack) => {
        if (req) {
            var data = req.body;
            // console.log('data', data);
            // return;
            var postImages = req.files;
            console.log('--------files--------------', postImages);
            // return;


            // return;

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


                        new userPostSchema(userPostObj).save(async function (err, userPost) {
                            if (err) {
                                console.log(err);
                                callBack({
                                    success: false,
                                    STATUSCODE: 500,
                                    message: 'Something went wrong',
                                    response_data: {}
                                });
                            } else {
                                if (postImages != null) {

                                    var imgFnd = 0;
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

                                    // if (Array.isArray(postImages.video) == true) {
                                    //     if (imgFnd == 0) {
                                    //         var postImagesAllImgs = [];
                                    //     }
                                    //     if (postImages.video.length > 0) {
                                    //         for (let vid of postImages.video) {
                                    //             postImagesAllImgs.push(vid);
                                    //         }
                                    //     }


                                    // } else {
                                    //     if (imgFnd == 0) {
                                    //         var postImagesAllImgs = [];
                                    //     }

                                    //     var postImagesAllImgsObj = postImages.video;
                                    //     postImagesAllImgs.push(postImagesAllImgsObj);
                                    // }

                                    console.log('------------postImagesAllImgs--------------', postImagesAllImgs);
                                    // return;

                                    if (postImagesAllImgs.length > 0) {
                                        var userPostDocumentObjArr = [];
                                        var imgExErr = 0;
                                        var imgUp = 0;
                                        var postImgLength = postImagesAllImgs.length;


                                        for (let postImagesAllImgVal of postImagesAllImgs) {
                                            console.log('postImagesAllImgVal', postImagesAllImgVal);
                                            var filename = postImagesAllImgVal.name;
                                            console.log('--------------------------------------------');
                                            console.log(filename.substring(filename.indexOf('.') + 1));
                                            var fileArr = filename.split(".");
                                            console.log('fileArr', fileArr);
                                            //var lastExt = (fileArr.length - 1);
                                            if (fileArr.length == 2) {
                                                var ext = fileArr[1];
                                            } else if (fileArr.length == 3) {
                                                var ext = fileArr[2];
                                            } else {
                                                var ext = fileArr[1];
                                                imgExErr++;
                                            }
                                            console.log('ext', ext);

                                            if (!["JPG", "JPEG", "PNG", "jpg", "jpeg", "bmp", "gif", "png", "x-png", "avi", "flv", "wmv", "mp4", "mov", "MOV", "MP4"].includes(ext)) {
                                                console.log('filename', filename);

                                                imgExErr++;
                                            }

                                        }

                                        if (imgExErr == 0) {
                                            var i = 0;
                                            for (let postImagesAllImg of postImagesAllImgs) {

                                                var userImagesObj = {
                                                    userId: result._id,
                                                    postId: userPost._id,
                                                    album: data.album,
                                                    caption: data.caption,
                                                    arrange: i
                                                }
                                                //Get image extension
                                                var ext = getExtension(postImagesAllImg.name);

                                                if (["jpg", "jpeg", "bmp", "gif", "png", "x-png"].includes(ext)) {
                                                    userImagesObj.type = 'IMAGE'
                                                    userImagesObj.thumb = '';
                                                } else {
                                                    userImagesObj.type = 'VIDEO';

                                                    //THUMBAIL
                                                    var thumbImagesAllImg = req.files.thumb;

                                                    console.log('thumbImagesAllImg',thumbImagesAllImg);
                                                    //Get image extension
                                                    var thumbext = getExtension(thumbImagesAllImg.name);
                                                    let sampleThumb = thumbImagesAllImg;
                                                    var thumb_name = `thumb-${Math.floor(Math.random() * 10000)}${userPost._id}${Math.floor(Math.random() * 1000)}${Math.floor(Date.now() / 1000)}.${thumbext}`;

                                                    await sampleThumb.mv(`public/img/post/${thumb_name}`, function (err) {
                                                        if (err) {
                                                            console.log(err);
                                                        }
                                                    });
                                                    userImagesObj.thumb = thumb_name;
                                                }

                                                // The name of the input field (i.e. "image") is used to retrieve the uploaded file
                                                let sampleFile = postImagesAllImg;

                                                var file_name = `post-${Math.floor(Math.random() * 10000)}${userPost._id}${Math.floor(Math.random() * 1000)}${Math.floor(Date.now() / 1000)}.${ext}`;
                                                userImagesObj.file = file_name;


                                                userPostDocumentObjArr.push(userImagesObj);
                                                // console.log('file_name', file_name);
                                                // Use the mv() method to place the file somewhere on your server
                                                await sampleFile.mv(`public/img/post/${file_name}`, function (err) {
                                                    if (err) {
                                                        console.log(err);
                                                    } else {

                                                        imgUp++;

                                                        if (postImgLength == imgUp) {
                                                            userFileSchema.insertMany(userPostDocumentObjArr, async function (err, postDocresult) {
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
                                                                        await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'FILE' } });
                                                                        callBack({
                                                                            success: true,
                                                                            STATUSCODE: 200,
                                                                            message: 'Post added successfully',
                                                                            response_data: {}
                                                                        });


                                                                    }
                                                                }
                                                            });
                                                        }



                                                    }
                                                })
                                                i++;
                                            }

                                        } else {
                                            userPostSchema.deleteOne({ _id: userPost._id }, function (err) {
                                                if (err) {
                                                    console.log(err);
                                                }
                                                // deleted at most one tank document
                                            });
                                            callBack({
                                                success: false,
                                                STATUSCODE: 422,
                                                message: 'Invalid document format/name',
                                                response_data: {}
                                            });
                                        }



                                    } else {
                                        await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

                                        callBack({
                                            success: true,
                                            STATUSCODE: 200,
                                            message: 'Post added successfully',
                                            response_data: {}
                                        });
                                    }

                                } else {
                                    await userPostSchema.updateOne({ _id: userPost._id }, { $set: { postType: 'NORMAL' } });

                                    callBack({
                                        success: true,
                                        STATUSCODE: 200,
                                        message: 'Post added successfully',
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
    updatePost: (req, callBack) => {
        if (req) {
            var data = req.body;
            // console.log('data', data);
            // return;
            var postImages = req.files;
            console.log('--------files--------------', postImages);
            // return;


            // return;

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
                                console.log('data.postId', data.postId);
                                let i = 0;
                                if (oldFileIdsArray.length > 0) {
                                    
                                    for(let oldf of oldFileIdsArray) {
                                        var updateFile = await userFileSchema.updateOne({ _id: oldf }, { $set: {arrange : i} });
                                        console.log('updateFile',i,updateFile);
                                        i++;
                                    }
                                    var userFileDatas = await userFileSchema.find({ postId: data.postId, _id: { $nin: oldFileIdsArray } });

                                    console.log('userFileDatas', userFileDatas);

                                    if (userFileDatas.length > 0) {



                                        for (let userFl of userFileDatas) {

                                            var getres = await userFileSchema.deleteOne({ _id: userFl._id });

                                            console.log('getres', getres);

                                            if (userFl.file != '') {
                                                var fs = require('fs');
                                                var filePath = `public/img/post/${userFl.file}`;
                                                fs.unlink(filePath, (err) => {
                                                    console.log('err', err);
                                                });
                                                var filePathThumb = `public/img/post/${userFl.thumb}`;
                                                fs.unlink(filePathThumb, (errThumb) => {
                                                    console.log('errThumb', errThumb);
                                                });
                                            }
                                        }

                                    }
                                }
                                if (postImages != null) {



                                    var imgFnd = 0;
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

                                    // if (Array.isArray(postImages.video) == true) {
                                    //     if (imgFnd == 0) {
                                    //         var postImagesAllImgs = [];
                                    //     }
                                    //     if (postImages.video.length > 0) {
                                    //         for (let vid of postImages.video) {
                                    //             postImagesAllImgs.push(vid);
                                    //         }
                                    //     }


                                    // } else {
                                    //     if (imgFnd == 0) {
                                    //         var postImagesAllImgs = [];
                                    //     }

                                    //     var postImagesAllImgsObj = postImages.video;
                                    //     postImagesAllImgs.push(postImagesAllImgsObj);
                                    // }

                                    console.log('------------postImagesAllImgs--------------', postImagesAllImgs);
                                    // return;

                                    if (postImagesAllImgs.length > 0) {
                                        var userPostDocumentObjArr = [];
                                        var imgExErr = 0;
                                        var imgUp = 0;
                                        var postImgLength = postImagesAllImgs.length;


                                        for (let postImagesAllImgVal of postImagesAllImgs) {
                                            console.log('postImagesAllImgVal', postImagesAllImgVal);
                                            var filename = postImagesAllImgVal.name;
                                            console.log('--------------------------------------------');
                                            console.log(filename.substring(filename.indexOf('.') + 1));
                                            var fileArr = filename.split(".");
                                            console.log('fileArr', fileArr);
                                            //var lastExt = (fileArr.length - 1);
                                            if (fileArr.length == 2) {
                                                var ext = fileArr[1];
                                            } else if (fileArr.length == 3) {
                                                var ext = fileArr[2];
                                            } else {
                                                var ext = fileArr[1];
                                                imgExErr++;
                                            }
                                            console.log('ext', ext);

                                            if (!["JPG", "JPEG", "PNG", "jpg", "jpeg", "bmp", "gif", "png", "x-png", "avi", "flv", "wmv", "mp4", "mov", "MOV", "MP4"].includes(ext)) {
                                                console.log('filename', filename);

                                                imgExErr++;
                                            }

                                        }

                                        if (imgExErr == 0) {

                                            for (let postImagesAllImg of postImagesAllImgs) {

                                                var userImagesObj = {
                                                    userId: result._id,
                                                    postId: data.postId,
                                                    album: data.album,
                                                    caption: data.caption,
                                                    arrange: i
                                                }
                                                //Get image extension
                                                var ext = getExtension(postImagesAllImg.name);

                                                if (["jpg", "jpeg", "bmp", "gif", "png", "x-png"].includes(ext)) {
                                                    userImagesObj.type = 'IMAGE'
                                                    userImagesObj.thumb = '';
                                                } else {
                                                    userImagesObj.type = 'VIDEO';

                                                    //THUMBAIL
                                                    var thumbImagesAllImg = req.files.thumb;
                                                    //Get image extension
                                                    var thumbext = getExtension(thumbImagesAllImg.name);
                                                    let sampleThumb = thumbImagesAllImg;
                                                    var thumb_name = `thumb-${Math.floor(Math.random() * 10000)}${data.postId}${Math.floor(Math.random() * 1000)}${Math.floor(Date.now() / 1000)}.${thumbext}`;

                                                    await sampleThumb.mv(`public/img/post/${thumb_name}`, function (err) {
                                                        if (err) {
                                                            console.log(err);
                                                        }
                                                    });
                                                    userImagesObj.thumb = thumb_name;
                                                }

                                                // The name of the input field (i.e. "image") is used to retrieve the uploaded file
                                                let sampleFile = postImagesAllImg;

                                                var file_name = `post-${Math.floor(Math.random() * 10000)}${data.postId}${Math.floor(Math.random() * 1000)}${Math.floor(Date.now() / 1000)}.${ext}`;
                                                userImagesObj.file = file_name;


                                                userPostDocumentObjArr.push(userImagesObj);
                                                // console.log('file_name', file_name);
                                                // Use the mv() method to place the file somewhere on your server
                                                await sampleFile.mv(`public/img/post/${file_name}`, function (err) {
                                                    if (err) {
                                                        console.log(err);
                                                    } else {

                                                        imgUp++;

                                                        if (postImgLength == imgUp) {
                                                            console.log('userPostDocumentObjArr', userPostDocumentObjArr);
                                                            userFileSchema.insertMany(userPostDocumentObjArr, async function (err, postDocresult) {
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
                                                                        await userPostSchema.updateOne({ _id: data.postId }, { $set: { postType: 'FILE' } });
                                                                        callBack({
                                                                            success: true,
                                                                            STATUSCODE: 200,
                                                                            message: 'Post updated successfully',
                                                                            response_data: {}
                                                                        });


                                                                    }
                                                                }
                                                            });
                                                        }



                                                    }
                                                })
                                                i++;
                                            }

                                        } else {
                                            userPostSchema.deleteOne({ _id: userPost._id }, function (err) {
                                                if (err) {
                                                    console.log(err);
                                                }
                                                // deleted at most one tank document
                                            });
                                            callBack({
                                                success: false,
                                                STATUSCODE: 422,
                                                message: 'Invalid document format/name',
                                                response_data: {}
                                            });
                                        }



                                    } else {
                                        var userImagesObj = {
                                            album: data.album,
                                            caption: data.caption
                                        }

                                        await userFileSchema.updateMany({ postId: data.postId }, { $set: userImagesObj });

                                        callBack({
                                            success: true,
                                            STATUSCODE: 200,
                                            message: 'Post uploaded successfully',
                                            response_data: {}
                                        });
                                    }

                                } else {

                                    var userImagesObj = {
                                        album: data.album,
                                        caption: data.caption
                                    }

                                    await userFileSchema.updateMany({ postId: data.postId }, { $set: userImagesObj });

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
    home: (req, callBack) => {
        if (req) {
            var data = req.body;
            // console.log('data', data);
            // return;

            userFileSchema
                .aggregate(
                    [
                        { "$match": { userId: data.userId } },
                        {
                            "$group": {
                                "_id": { name: "$album" }
                            }
                        }
                    ])
                    .sort({arrange: 'asc'})

                .then(async (albumNames) => {
                    var responseData = {};
                    var fileArr = [];
                   // console.log('albumNames', albumNames);
                    if (albumNames.length > 0) {
                        for (let albNm of albumNames) {
                            var fileObj = {};
                            var albNmU = albNm._id.name;
                          //  console.log('albNmU', albNmU);
                            fileObj['album'] = albNmU;
                            var fetAlbmData = await userFileSchema.find({ album: albNmU }).sort({arrange: 'asc'});
                            fileObj['data'] = fetAlbmData;

                            //GetComment, Like
                            var getPostId = fetAlbmData[0].postId;


                            //GetPostLike
                            fileObj['post'] = await userPostSchema.findOne({ _id: getPostId });

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

                            var fetchPostTribe = await userPostSchema.find({ tribe: { $in: tribeId }, userId: { $ne: data.userId }, postType: 'FILE', createdAt: { "$gt": new Date(Date.now() - 24 * 60 * 60 * 1000) } });

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

                            var fetchIc = await userPostSchema.find({ userId: circleId, postType: 'FILE', createdAt: { "$gt": new Date(Date.now() - 24 * 60 * 60 * 1000) } });

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

            userFileSchema.findOne({ _id: imageId, userId: userId })
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

            userPostSchema.findOne({ _id: postId })
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
                            var message = `${likedUser.fullName} liked on your post`;

                            if(userPost.userId.toString() != userId.toString()) {
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

            userPostSchema.findOne({ _id: postId })
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

                    if (userPost != null) {

                        const postData = {
                            postId: postId,
                            comment: req.body.comment,
                            commentedBy: userId,
                        };
                        const newComment = CommentSchema(postData);
                        const savedComment = await newComment.save();
                        await userPostSchema.findOneAndUpdate(
                            { _id: postId },
                            {
                                $push: {
                                    comments: savedComment._id,
                                },
                            }
                        );


                        //Notification End

                        var commentedUser = await userSchema.findOne({ _id: userId.toString() });
                        var message = `${commentedUser.fullName} commented on your post`;

                        if(userPost.userId.toString() != userId.toString()) {
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
}

function getExtension(filename) {
    console.log('filename',filename);
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