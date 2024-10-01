var tribeSchema = require("../../schema/Tribe");
var mapUserTribeSchema = require("../../schema/MapUserTribe");
var mapUserInnerCircleSchema = require("../../schema/MapUserInnerCircle");
var blockUserTribeSchema = require("../../schema/BlockUserTribe");
var BlockUserSchema = require("../../schema/BlockUser");
var userSchema = require("../../schema/User");
const config = require("../../config");

module.exports = {
  createTribe: (req, callBack) => {
    if (req) {
      var data = req.body;
      console.log("data", data);

      var peopleStr = data.people;
      var peopleArr = peopleStr.split(",");
      peopleArr.push(data.userId);
      var file_name = "";

      console.log("req.files", req.files, typeof req.files);

      // console.log('peopleArr', peopleArr);
      // return;
      // console.log("sayan")
      if (req.files != null || req.files != undefined) {
        // console.log("sayan")
        //Get image extension
        // console.log("this is file ============ create tribe ===========", req.files.image.name)
        var ext = getExtension(req.files.image.name);

        // The name of the input field (i.e. "image") is used to retrieve the uploaded file
        let sampleFile = req.files.image;

        file_name = `tribedp-${Math.floor(Math.random() * 1000)}-${Math.floor(
          Date.now() / 1000
        )}.${ext}`;
        console.log("filename===================", file_name);

        // Use the mv() method to place the file somewhere on your server
        sampleFile.mv(`public/img/post/${file_name}`, function (err) {
          if (err) {
            callBack({
              success: false,
              STATUSCODE: 500,
              message: "Internal error",
              response_data: {},
            });
          } else {
            console.log("File Uploaded");
          }
        });
      }

      var tribeObj = {
        createrUserId: data.userId,
        image: file_name,
        name: data.name,
        type: data.type,
      };

      new tribeSchema(tribeObj).save(async function (err, tribe) {
        if (err) {
          console.log(err);
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Something went wrong",
            response_data: {},
          });
        } else {
          var tribeId = tribe._id;

          var mapUserTribeArr = [];
          if (peopleArr.length > 0) {
            for (let people of peopleArr) {
              var mapUserTribeObj = {
                userId: people,
                tribeId: tribeId,
                type: tribe.type,
              };

              mapUserTribeArr.push(mapUserTribeObj);
            }
          }

          mapUserTribeSchema.insertMany(
            mapUserTribeArr,
            function (error, mapUser) {
              if (error) {
                console.log(error);
                callBack({
                  success: false,
                  STATUSCODE: 500,
                  message: "Something went wrong",
                  response_data: {},
                });
              } else {
                if (data.type == "Tribe") {
                  callBack({
                    success: true,
                    STATUSCODE: 200,
                    message: "Tribe added successfully",
                    response_data: {},
                  });
                } else {
                  callBack({
                    success: true,
                    STATUSCODE: 200,
                    message: "Inner Circle added successfully",
                    response_data: {},
                  });
                }
              }
            }
          );
        }
      });

      return;
    }
  },
  tribeList: (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;

      mapUserTribeSchema
        .find({userId: userId})
        .then(async (userTribe) => {
          var tribeInfoArr = [];
          if (userTribe.length > 0) {
            for (let userTrb of userTribe) {
              var userTribeObj = {};
              var tribeData = await tribeSchema.findOne({
                _id: userTrb.tribeId,
                type: "Tribe",
              });
              console.log("this is tribe data === ", tribeData);
              if (tribeData == null) {
                console.log("This is null");
              } else {
                userTribeObj._id = tribeData._id;
                userTribeObj.createrUserId = tribeData.createrUserId;
                userTribeObj.image = tribeData.image;
                userTribeObj.name = tribeData.name;
                userTribeObj.type = tribeData.type;
                userTribeObj.tribeImageUrl = `${config.serverhost}:${config.port}/img/post/`;
                userTribeObj.userImageUrl = `${config.serverhost}:${config.port}/img/profile-pic/`;

                var allTribeUser = await mapUserTribeSchema.find({
                  tribeId: userTribeObj._id,
                });

                userTribeObj.countPeople = allTribeUser.length;

                var tribeArr = [];
                if (allTribeUser.length > 0) {
                  for (let allTrb of allTribeUser) {
                    var checkBlock = await checkblockUser(
                      userId,
                      allTrb.userId
                    );
                    console.log("checkBlock", checkBlock);
                    if (checkBlock == false) {
                      var allTrbObj = {};
                      var userData = await userSchema.findOne({
                        _id: allTrb.userId,
                      });
                      allTrbObj = userData;
                      // console.log('allTrbObj',allTrbObj);
                      tribeArr.push(allTrbObj);
                    }
                  }
                }

                userTribeObj.tribeUserData = tribeArr;

                tribeInfoArr.push(userTribeObj);
              }

              console.log("userTribeObj =====", userTribeObj);
            }
          }

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "Tribe list and info",
            response_data: {data: tribeInfoArr},
          });
        })
        .catch((err) => {
          console.log("err", err);
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Something went wrong",
            response_data: {},
          });
        });
    }
  },
  addInnerCircleMember: (req, callBack) => {
    if (req) {
      var data = req.body;
      console.log("data", data);

      var peopleStr = data.people;
      var peopleArr = peopleStr.split(",");

      var mapUserIcArr = [];

      if (peopleArr.length > 0) {
        for (let people of peopleArr) {
          var mapUserInnerCircleObj = {
            circleUserId: people,
            userId: data.userId,
          };

          mapUserIcArr.push(mapUserInnerCircleObj);
        }
      }

      mapUserInnerCircleSchema.insertMany(
        mapUserIcArr,
        function (error, mapUser) {
          if (error) {
            console.log(error);
            callBack({
              success: false,
              STATUSCODE: 500,
              message: "Something went wrong",
              response_data: {},
            });
          } else {
            callBack({
              success: true,
              STATUSCODE: 200,
              message: "Inner circle added successfully",
              response_data: {},
            });
          }
        }
      );
    }
  },
  innerCircleList: async (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;

      mapUserTribeSchema
        .find({userId: userId})
        .then(async (userTribe) => {
          var tribeInfoArr = [];
          if (userTribe.length > 0) {
            for (let userTrb of userTribe) {
              var userTribeObj = {};
              var tribeData = await tribeSchema.findOne({
                _id: userTrb.tribeId,
                type: "INNERCIRCLE",
              });
              console.log("this is tribe data === ", tribeData);
              if (tribeData == null) {
                console.log("This is null");
              } else {
                userTribeObj._id = tribeData._id;
                userTribeObj.createrUserId = tribeData.createrUserId;
                userTribeObj.image = tribeData.image;
                userTribeObj.name = tribeData.name;
                userTribeObj.type = tribeData.type;
                userTribeObj.tribeImageUrl = `${config.serverhost}:${config.port}/img/post/`;
                userTribeObj.userImageUrl = `${config.serverhost}:${config.port}/img/profile-pic/`;

                var allTribeUser = await mapUserTribeSchema.find({
                  tribeId: userTribeObj._id,
                });

                userTribeObj.countPeople = allTribeUser.length;

                var tribeArr = [];
                if (allTribeUser.length > 0) {
                  for (let allTrb of allTribeUser) {
                    var checkBlock = await checkblockUser(
                      userId,
                      allTrb.userId
                    );
                    console.log("checkBlock", checkBlock);
                    if (checkBlock == false) {
                      var allTrbObj = {};
                      var userData = await userSchema.findOne({
                        _id: allTrb.userId,
                      });
                      allTrbObj = userData;
                      // console.log('allTrbObj',allTrbObj);
                      tribeArr.push(allTrbObj);
                    }
                  }
                }

                userTribeObj.tribeUserData = tribeArr;

                tribeInfoArr.push(userTribeObj);
              }

              console.log("userTribeObj =====", userTribeObj);
            }
          }

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "Tribe list and info",
            response_data: {data: tribeInfoArr},
          });
        })
        .catch((err) => {
          console.log("err", err);
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Something went wrong",
            response_data: {},
          });
        });
    }
    // if (req) {
    //     var data = req.body;
    //     var userId = data.userId;
    //     var type = data.type

    //     var allICUser = await mapUserTribeSchema.find({ userId: userId, type: type });

    //     var tribeArr = [];
    //     if (allICUser.length > 0) {
    //         for (let allIC of allICUser) {
    //             var allICObj = {}
    //             var userData = await userSchema.find({ _id: allIC.circleUserId});
    //             allICObj = userData;

    //             // console.log('allTrbObj',allTrbObj);
    //             tribeArr.push(allICObj);
    //         }
    //     }

    //     callBack({
    //         success: true,
    //         STATUSCODE: 200,
    //         message: 'Inner list and info',
    //         response_data: { data: userData, userImageUrl: `${config.serverhost}:${config.port}/img/profile-pic/` }
    //     });

    // }
  },
  blockUser: async (req, callBack) => {
    if (req) {
      var data = req.body;
      console.log("data", data);

      var blockedUserId = data.blockedUserId;
      var userId = data.userId;

      var checkBlock = await checkblockUser(userId, blockedUserId);
      console.log("checkBlock", checkBlock);
      if (checkBlock == false) {
        var blockUserObj = {
          userId: userId,
          blockUserId: blockedUserId,
        };
        new BlockUserSchema(blockUserObj).save(async function (err, tribeUser) {
          if (err) {
            callBack({
              success: false,
              STATUSCODE: 500,
              message: "Internal DB error",
              response_data: {},
            });
          } else {
            callBack({
              success: true,
              STATUSCODE: 200,
              message: "User blocked successfully",
              response_data: {},
            });
          }
        });
      } else {
        callBack({
          success: true,
          STATUSCODE: 200,
          message: "User blocked successfully",
          response_data: {},
        });
      }
    }
  },
  unblockUser: (req, callBack) => {
    if (req) {
      var data = req.body;
      console.log("data", data);

      var blockedUserId = data.blockedUserId;
      var userId = data.userId;

      var blockUserObj = {
        userId: userId,
        blockUserId: blockedUserId,
      };

      BlockUserSchema.deleteOne(blockUserObj, function (err) {
        if (err) {
          console.log(err);
        }
        // deleted at most one tank document
      });
      callBack({
        success: true,
        STATUSCODE: 200,
        message: "User unblocked successfully",
        response_data: {},
      });
    }
  },
  blockUserList: async (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;

      var allICUser = await BlockUserSchema.find({userId: userId});

      var tribeArr = [];
      if (allICUser.length > 0) {
        for (let allIC of allICUser) {
          var allICObj = {};
          var userData = await userSchema.findOne({_id: allIC.blockUserId});
          allICObj = userData;

          // console.log('allTrbObj',allTrbObj);
          tribeArr.push(allICObj);
        }
      }

      callBack({
        success: true,
        STATUSCODE: 200,
        message: "Inner list and info",
        response_data: {
          data: tribeArr,
          userImageUrl: `${config.serverhost}:${config.port}/img/profile-pic/`,
        },
      });
    }
  },
  leaveTribe: (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;
      var tribeId = data.tribeId;

      mapUserTribeSchema
        .findOne({userId: userId, tribeId: tribeId})
        .then(async (userTribe) => {
          if (userTribe != null) {
            mapUserTribeSchema.deleteOne(
              {_id: userTribe._id.toString()},
              function (err) {
                if (err) {
                  console.log(err);
                }
                // deleted at most one tank document
              }
            );

            callBack({
              success: true,
              STATUSCODE: 200,
              message: "Leaved successfully",
              response_data: {},
            });
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "Something went wrong",
              response_data: {},
            });
          }
        })
        .catch((err) => {
          console.log("err", err);
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Something went wrong",
            response_data: {},
          });
        });
    }
  },
  blockTribe: (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;
      var tribeId = data.tribeId;

      mapUserTribeSchema
        .findOne({userId: userId, tribeId: tribeId})
        .then(async (userTribe) => {
          if (userTribe != null) {
            var blockUserObj = {
              userId: userId,
              tribeId: tribeId,
            };
            new blockUserTribeSchema(blockUserObj).save(async function (
              err,
              tribeUser
            ) {
              if (err) {
                callBack({
                  success: false,
                  STATUSCODE: 500,
                  message: "Internal DB error",
                  response_data: {},
                });
              } else {
                mapUserTribeSchema.deleteOne(
                  {_id: userTribe._id.toString()},
                  function (err) {
                    if (err) {
                      console.log(err);
                    }
                    // deleted at most one tank document
                  }
                );
                callBack({
                  success: true,
                  STATUSCODE: 200,
                  message: "Tribe blocked successfully",
                  response_data: {},
                });
              }
            });
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "Something went wrong",
              response_data: {},
            });
          }
        })
        .catch((err) => {
          console.log("err", err);
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Something went wrong",
            response_data: {},
          });
        });
    }
  },
  unBlockTribe: (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;
      var tribeId = data.tribeId;

      blockUserTribeSchema.deleteOne(
        {tribeId: tribeId.toString(), userId: userId.toString()},
        function (err) {
          if (err) {
            console.log(err);
          }
          // deleted at most one tank document
        }
      );
      callBack({
        success: true,
        STATUSCODE: 200,
        message: "Tribe unblocked successfully",
        response_data: {},
      });
    }
  },
  blockTribeList: (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;

      blockUserTribeSchema
        .find({userId: userId})
        .then(async (userTribe) => {
          var tribeInfoArr = [];
          if (userTribe.length > 0) {
            for (let userTrb of userTribe) {
              var userTribeObj = {};
              var tribeData = await tribeSchema.findOne({_id: userTrb.tribeId});
              userTribeObj._id = tribeData._id;
              userTribeObj.createrUserId = tribeData.createrUserId;
              userTribeObj.image = tribeData.image;
              userTribeObj.name = tribeData.name;
              userTribeObj.type = tribeData.type;
              userTribeObj.tribeImageUrl = `${config.serverhost}:${config.port}/img/post/`;
              userTribeObj.userImageUrl = `${config.serverhost}:${config.port}/img/profile-pic/`;

              // var allTribeUser = await mapUserTribeSchema.find({ tribeId: userTrb.tribeId });
              // userTribeObj.countPeople = allTribeUser.length;

              // var tribeArr = [];
              // if (allTribeUser.length > 0) {
              //     for (let allTrb of allTribeUser) {
              //         var allTrbObj = {}
              //         var userData = await userSchema.findOne({ _id: allTrb.userId });
              //         allTrbObj = userData;
              //         // console.log('allTrbObj',allTrbObj);
              //         tribeArr.push(allTrbObj);
              //     }
              // }

              // userTribeObj.tribeUserData = tribeArr;

              tribeInfoArr.push(userTribeObj);
            }
          }

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "Block tribe list and info",
            response_data: {data: tribeInfoArr},
          });
        })
        .catch((err) => {
          console.log("err", err);
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Something went wrong",
            response_data: {},
          });
        });
    }
  },
};

function getExtension(filename) {
  return filename.substring(filename.indexOf(".") + 1);
}

function checkblockUser(userId, blockUserId) {
  return new Promise(function (resolve, reject) {
    var andReqCondObj = {};
    var reqArr = [];
    var reqCondOne = {
      $and: [{userId: userId.toString()}, {blockUserId: blockUserId}],
    };
    var reqCondTwo = {
      $and: [{userId: blockUserId}, {blockUserId: userId.toString()}],
    };

    reqArr.push(reqCondOne);
    reqArr.push(reqCondTwo);

    andReqCondObj["$or"] = reqArr;

    BlockUserSchema.findOne(andReqCondObj)
      .then(async (blockCheck) => {
        // console.log('notSetting',notSetting);
        if (blockCheck != null) {
          return resolve(true);
        } else {
          return resolve(false);
        }
      })
      .catch((error) => {
        return resolve(false);
      });
  });
}
