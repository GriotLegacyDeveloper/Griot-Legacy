var async = require("async");
var jwt = require("jsonwebtoken");
var userSchema = require("../../schema/User");
var userDeviceLoginSchema = require("../../schema/UserDeviceLogin");
var mapUserInnerCircleSchema = require("../../schema/MapUserInnerCircle");
var mapUserTribeSchema = require("../../schema/MapUserTribe");
var sendInvitationSchema = require("../../schema/SendInvitation");
var userNotificationSchema = require("../../schema/UserNotification");
var connectedUserSchema = require("../../schema/ConnectUser");
var userPostSchema = require("../../schema/UserPost");
var userFileSchema = require("../../schema/UserFile");
var BlockUserSchema = require("../../schema/BlockUser");
var MessageSchema = require("../../schema/Message");
var ChatSchema = require("../../schema/GroupChat");
var GroupMessageSchema = require("../../schema/GroupMessage");
var groupFileSchema = require("../../schema/GroupFile");
var appUsageSchema = require("../../schema/Appusage");
var reportUserSchema = require("../../schema/ReportUser");
var awsConfig = require("../../awsConfig.json");
var storageSchema = require("../../schema/storageSchema");
var packageSchema = require("../../schema/package");

const path = require("path");
const fullPath = path.resolve("./awsConfig.json");
var AWS = require("aws-sdk");
AWS.config.loadFromPath(fullPath);

const config = require("../../config");
const mail = require("../../modules/sendEmail");
var bcrypt = require("bcryptjs");
var fs = require("fs"); // call fs(file system to access file system of our server)
var mime = require("mime");

AWS.config.update({
  accessKeyId: awsConfig.accessKeyId,
  secretAccessKey: awsConfig.secretAccessKey,
  region: awsConfig.region,
});

const s3 = new AWS.S3();

module.exports = {
  register: async (data, callBack) => {
    if (data) {
      console.log("data", data.body);
      var fullName = data.body.fullName;
      var email = data.body.email;
      var phone = data.body.phone;
      var countryCode = data.body.countryCode;
      if (email != "" || phone != "") {
        var userObj = {};
        var em = 0;
        var ph = 0;
        if (email != "") {
          em = 1;
        }
        if (phone != "") {
          ph = 1;
        }
        if (em == 1 && ph == 1) {
          var userObj = {$or: [{email: email}, {phone: phone}]};
        } else if (em == 1) {
          var userObj = {email: email};
          var phone = 0;
        } else {
          var userObj = {phone: phone};
        }

        // console.log("msg", msg)
        await userSchema
          .findOne(userObj)
          .collation({locale: "en", strength: 2})
          .then(async function (resp) {
            if (resp == null) {
              var userAddObj = {
                fullName: fullName,
                email: email,
                countryCode: data.body.countryCode,
                phone: phone,
                password: data.body.password,
                profileImage: "",
                status: "ACTIVE",
                badgeCount: 0,
                gender: data.body.gender,
                relationship: data.body.relationship,
              };

              if (em == 1 && ph == 1) {
                var userLoginType = "EMAIL";
                userAddObj.userLoginType = "EMAIL";
              } else if (em == 1) {
                var userLoginType = "EMAIL";
                userAddObj.userLoginType = "EMAIL";
              } else {
                var userLoginType = "PHONE";
                userAddObj.userLoginType = "PHONE";
              }
              var date = data.body.dateOfBirth;
              if (date != "" && date != undefined) {
                // var dateSpl = date.split("/");
                // var month = dateSpl[1];
                // var day = dateSpl[0];
                // var year = dateSpl[2];
                // var dateNew = new Date(`${month}-${day}-${year} 00:00:00`);
                userAddObj["dateOfBirth"] = date;
              }
              await new userSchema(userAddObj).save(async function (err, user) {
                if (err) {
                  console.log("err", err);
                  callBack({
                    success: false,
                    STATUSCODE: 500,
                    message: "Internal DB error",
                    response_data: {},
                  });
                } else {
                  try {
                    // create user folder in s3 bucket
                    const storageSizeLimit = 1 * 1024 * 1024 * 1024; // 1GB

                    // Create user folder in S3 bucket
                    const userFolder = `${user._id}/`;
                    await s3
                      .putObject({
                        Bucket: "griotlegacy",
                        Key: userFolder,
                        Body: "",
                        ACL: "private",
                        Metadata: {
                          "x-amz-meta-storage-size-limit":
                            storageSizeLimit.toString(),
                        },
                      })
                      .promise();
                    // Save storage details in the database
                    const storage = new storageSchema({
                      user: user._id,
                      allocatedSize: storageSizeLimit,
                    });
                    await storage.save();
                  } catch (err) {
                    console.log("<<<bucket err>>>", err);
                    return;
                  }

                  if (userLoginType == "EMAIL") {
                    var userOtp = await sendVerificationCode(user);

                    var respData = {
                      userId: user._id,
                      sid: "1234",
                    };
                  } else {
                    var userResp = await sendSMS(countryCode, phone);

                    var respData = {
                      userId: user._id,
                      sid: userResp.serviceSid,
                    };
                  }

                  if (em == 1 && ph == 1) {
                    var regMsg =
                      "Please check your email. We have sent a code to be used to verify your account.";
                  } else if (em == 1) {
                    var regMsg =
                      "Please check your email. We have sent a code to be used to verify your account.";
                  } else {
                    var regMsg =
                      "Please check your phone. We have sent a code to be used to verify your account.";
                  }

                  callBack({
                    success: true,
                    STATUSCODE: 210,
                    message: regMsg,
                    response_data: respData,
                  });
                }
              });
            } else {
              if (resp.email == data.body.email) {
                callBack({
                  success: false,
                  STATUSCODE: 422,
                  message: "User Already exists for this email",
                  response_data: {},
                });
              } else if (
                resp.phone == data.body.phone &&
                resp.email == data.body.email
              ) {
                callBack({
                  success: false,
                  STATUSCODE: 422,
                  message: "User already exists for these email / phone",
                  response_data: {},
                });
              } else {
                callBack({
                  success: false,
                  STATUSCODE: 422,
                  message: "User already exists for this phone",
                  response_data: {},
                });
              }
            }
          })
          .catch(function (err) {
            callBack({
              success: false,
              STATUSCODE: 500,
              message: "Something went wrong",
              response_data: {},
            });
          });
      } else {
        callBack({
          success: false,
          STATUSCODE: 422,
          message: "You have to enter either email or phone",
          response_data: {},
        });
      }
    }
  },
  login: (data, callBack) => {
    if (data) {
      var email = data.body.user; //This field is eiter email or username
      var password = data.body.password;
      var appType = data.body.appType;
      var deviceToken = data.body.deviceToken;

      if (
        /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(data.body.user)
      ) {
        var loginCond = {email: data.body.user};
        loginUser = "EMAIL";
        loginErrMsg = "Invalid email or password";
      } else {
        var loginCond = {phone: data.body.user};
        loginUser = "PHONE";
        loginErrMsg = "Invalid phone or password";
      }

      userSchema
        .findOne(loginCond)
        .collation({locale: "en", strength: 2})
        .then(async function (user) {
          if (user != null) {
            const comparePass = bcrypt.compareSync(password, user.password);
            if (comparePass) {
              //CHECK USER STATUS

              var checkuserStatus = user.status;
              if (checkuserStatus == "INACTIVE") {
                //USER INACTIVE

                if (user.userLoginType == "EMAIL") {
                  var userOtp = await sendVerificationCode(user);

                  var respData = {
                    userId: user._id,
                    sid: "1234",
                  };
                } else {
                  var userResp = await sendSMS(user.countryCode, user.phone);

                  var respData = {
                    userId: user._id,
                    sid: userResp.serviceSid,
                  };
                }

                callBack({
                  success: true,
                  STATUSCODE: 210,
                  message:
                    "Please check your email/phone. We have sent a code to be used to verify your account.",
                  response_data: respData,
                });
              } else if (checkuserStatus == "WAITING FOR APPROVAL") {
                callBack({
                  success: false,
                  STATUSCODE: 422,
                  message:
                    "Your account has been deactivated, please contact admin.",
                  response_data: {},
                });
              } else {
                //ADD DATA IN USER LOGIN DEVICE TABLE
                var userDeviceData = {
                  userId: user._id,
                  appType: appType,
                  deviceToken: deviceToken,
                };

                new userDeviceLoginSchema(userDeviceData).save(async function (
                  err,
                  userDev
                ) {
                  if (err) {
                    console.log("err", err);
                    callBack({
                      success: false,
                      STATUSCODE: 500,
                      message: "Something went wrong",
                      response_data: {},
                    });
                  } else {
                    await userSchema.updateOne(
                      {_id: user._id},
                      {$set: {lastLogin: new Date()}}
                    );

                    var loginId = userDev._id;
                    const authToken = generateToken(user);
                    let response = {
                      userDetails: {
                        fullName: user.fullName,
                        userName: user.userName,
                        email: user.email,
                        countryCode: user.countryCode,
                        phone: user.phone,
                        userId: user._id,
                        loginId: loginId,
                        profileImage:
                          `${config.fileUrl}profile-pic/` + user.profileImage,
                      },
                      authToken: authToken,
                    };

                    if (user.profileImage != "") {
                      response.userDetails.profileImage =
                        `${config.fileUrl}profile-pic/` + user.profileImage;
                    } else {
                      response.userDetails.profileImage = "";
                    }
                    callBack({
                      success: true,
                      STATUSCODE: 200,
                      message: "Logged in successfully",
                      response_data: response,
                    });
                  }
                });
              }
            } else {
              console.log("huu");
              callBack({
                success: false,
                STATUSCODE: 422,
                message: "Email and/or password is incorrect",
                response_data: {},
              });
            }
          } else {
            console.log("hu hu ");
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "Email and/or password is incorrect",
              response_data: {},
            });
          }
        })
        .catch(function (err) {
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
  customerVerifyUser: (req, callBack) => {
    if (req) {
      var data = req.body;
      // return;
      var userId = data.userId;
      var appType = data.appType;
      var deviceToken = data.deviceToken;
      var sid = data.sid;
      var otp = data.otp;

      userSchema
        .findOne({_id: userId})
        .then(async (user) => {
          if (user != null) {
            console.log("user.userLoginType", user.userLoginType);
            var err = 0;
            if (user.userLoginType == "EMAIL") {
              if (user.verificationOTP == otp) {
                await userSchema.updateOne(
                  {_id: userId},
                  {$set: {status: "WAITING FOR APPROVAL"}}
                );
              } else {
                err++;
              }
            } else {
              const Cryptr = require("cryptr");
              const cryptr = new Cryptr("CARGORS");
              const accountSid = config.twilio.TWILIO_SID;
              const authToken = config.twilio.TWILIO_AUTHTOKEN;
              const client = require("twilio")(accountSid, authToken);

              if (sid == "1234" && config.twilio.testMode == "YES") {
                await userSchema.updateOne(
                  {_id: userId},
                  {$set: {status: "WAITING FOR APPROVAL"}}
                );
              } else {
                var code = otp;
                var phoneNo = `${user.countryCode}${user.phone}`;
                client.verify
                  .services(sid)
                  .verificationChecks.create({to: phoneNo, code: code})
                  .then(async function (verification_check) {
                    if (verification_check.status == "approved") {
                      await userSchema.updateOne(
                        {_id: userId},
                        {$set: {status: "WAITING FOR APPROVAL"}}
                      );
                    } else {
                      err++;
                    }
                  })
                  .catch(function (err) {
                    err++;
                  });
              }
            }
            if (err == 0) {
              //ADD DATA IN USER LOGIN DEVICE TABLE
              var userDeviceData = {
                userId: userId,
                appType: appType,
                deviceToken: deviceToken,
              };

              new userDeviceLoginSchema(userDeviceData).save(async function (
                err,
                userDev
              ) {
                if (err) {
                  console.log("err", err);
                  callBack({
                    success: false,
                    STATUSCODE: 500,
                    message: "Something went wrong",
                    response_data: {},
                  });
                } else {
                  var loginId = userDev._id;
                  const authToken = generateToken(user);

                  let response = {
                    userDetails: {
                      fullName: user.fullName,
                      userName: user.userName,
                      email: user.email,
                      countryCode: user.countryCode,
                      phone: user.phone,
                      userId: user._id,
                      loginId: loginId,
                      profileImage:
                        `${config.fileUrl}profile-pic/` + user.profileImage,
                    },
                    authToken: authToken,
                  };

                  if (user.profileImage != "") {
                    response.userDetails.profileImage =
                      `${config.fileUrl}profile-pic/` + user.profileImage;
                  } else {
                    response.userDetails.profileImage = "";
                  }

                  callBack({
                    success: true,
                    STATUSCODE: 200,
                    message: "Registration successfull",
                    response_data: response,
                  });
                }
              });
            } else {
              callBack({
                success: false,
                STATUSCODE: 422,
                message: "Invalid verification code",
                response_data: {},
              });
            }
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found.",
              response_data: {},
            });
          }
        })
        .catch(function (err) {
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
  forgotPassword: (req, callBack) => {
    if (req) {
      var data = req.body;
      var email = req.body.email;

      if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(data.user)) {
        var loginCond = {email: data.user};
        loginUser = "EMAIL";
        loginErrMsg = "Invalid email or password";
      } else {
        var loginCond = {phone: data.user};
        loginUser = "PHONE";
        loginErrMsg = "Invalid phone or password";
      }

      userSchema.findOne(loginCond, async function (err, customer) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (customer) {
            console.log("customer.userLoginType", customer.userLoginType);
            if (customer.userLoginType == "EMAIL") {
              let forgotPasswordOtp = Math.random()
                .toString()
                .replace("0.", "")
                .substr(0, 6);
              customer = customer.toObject();
              customer.forgotPasswordOtp = forgotPasswordOtp;
              try {
                mail("forgotPasswordMail")(customer.email, customer).send();

                await userSchema.updateOne(
                  {_id: customer._id},
                  {$set: {fpOTP: forgotPasswordOtp}}
                );

                callBack({
                  success: true,
                  STATUSCODE: 200,
                  message:
                    "Please check your email. We have sent a code to be used to reset password.",
                  response_data: {
                    id: customer._id,
                    user: data.user,
                    sid: "1234",
                  },
                });
              } catch (Error) {
                callBack({
                  success: false,
                  STATUSCODE: 500,
                  message: "Something went wrong while sending email",
                  response_data: {},
                });
              }
            } else {
              var userResp = await sendSMS(
                customer.countryCode,
                customer.phone
              );

              callBack({
                success: true,
                STATUSCODE: 200,
                message:
                  "Please check your phone. We have sent a code to be used to reset password.",
                response_data: {
                  id: customer._id,
                  user: data.user,
                  sid: userResp.serviceSid,
                },
              });
            }
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found",
              response_data: {},
            });
          }
        }
      });
    }
  },
  resendOTP: (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = req.body.userId;
      var type = req.body.type;

      userSchema.findOne({_id: userId}, async function (err, customer) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (customer) {
            if (type == "SIGN_UP") {
              if (customer.userLoginType == "EMAIL") {
                var userOtp = await sendVerificationCode(customer);

                var respData = {
                  userId: customer._id,
                  sid: "1234",
                };
                callBack({
                  success: true,
                  STATUSCODE: 200,
                  message:
                    "Please check your email. We have sent a code to be used to verify your account.",
                  response_data: {
                    id: customer._id,
                    sid: "1234",
                  },
                });
              } else {
                var userResp = await sendSMS(
                  customer.countryCode,
                  customer.phone
                );

                var respData = {
                  userId: customer._id,
                  sid: userResp.serviceSid,
                };

                callBack({
                  success: true,
                  STATUSCODE: 200,
                  message:
                    "Please check your email. We have sent a code to be used to verify your account.",
                  response_data: {
                    id: customer._id,
                    sid: userResp.serviceSid,
                  },
                });
              }
            } else {
              if (customer.userLoginType == "EMAIL") {
                let forgotPasswordOtp = Math.random()
                  .toString()
                  .replace("0.", "")
                  .substr(0, 6);
                customer = customer.toObject();
                customer.forgotPasswordOtp = forgotPasswordOtp;
                try {
                  mail("forgotPasswordMail")(customer.email, customer).send();

                  await userSchema.updateOne(
                    {_id: customer._id},
                    {$set: {fpOTP: forgotPasswordOtp}}
                  );

                  callBack({
                    success: true,
                    STATUSCODE: 200,
                    message:
                      "Please check your email. We have sent a code to be used to reset password.",
                    response_data: {
                      id: customer._id,
                      sid: "1234",
                    },
                  });
                } catch (Error) {
                  callBack({
                    success: false,
                    STATUSCODE: 500,
                    message: "Something went wrong while sending email",
                    response_data: {},
                  });
                }
              } else {
                var userResp = await sendSMS(
                  customer.countryCode,
                  customer.phone
                );

                callBack({
                  success: true,
                  STATUSCODE: 200,
                  message:
                    "Please check your phone. We have sent a code to be used to reset password.",
                  response_data: {
                    id: customer._id,
                    sid: userResp.serviceSid,
                  },
                });
              }
            }
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found",
              response_data: {},
            });
          }
        }
      });
    }
  },
  fpVerifyUser: (req, callBack) => {
    if (req) {
      var data = req.body;

      var userId = data.userId;
      var sid = data.sid;
      var otp = data.otp;

      userSchema
        .findOne({_id: userId})
        .then(async (user) => {
          if (user != null) {
            var err = 0;
            if (user.userLoginType == "EMAIL") {
              if (user.fpOTP == otp) {
                callBack({
                  success: true,
                  STATUSCODE: 200,
                  message: "Verified successfully",
                  response_data: {
                    userId: userId,
                  },
                });
              } else {
                err++;
              }
            } else {
              const Cryptr = require("cryptr");
              const cryptr = new Cryptr("CARGORS");

              const accountSid = config.twilio.TWILIO_SID;
              const authToken = config.twilio.TWILIO_AUTHTOKEN;
              const client = require("twilio")(accountSid, authToken);

              var sid = data.sid;
              if (sid == "1234" && config.twilio.testMode == "YES") {
                callBack({
                  success: true,
                  STATUSCODE: 200,
                  message: "Verified successfully",
                  response_data: {
                    userId: userId,
                  },
                });
              } else {
                var code = otp;
                var phoneNo = `${user.countryCode}${user.phone}`;

                client.verify
                  .services(sid)
                  .verificationChecks.create({to: phoneNo, code: code})
                  .then(async function (verification_check) {
                    if (verification_check.status == "approved") {
                      callBack({
                        success: true,
                        STATUSCODE: 200,
                        message: "Verified successfully",
                        response_data: {
                          userId: userId,
                        },
                      });
                    } else {
                      err++;
                    }
                  })
                  .catch(function (err) {
                    err++;
                  });
              }
            }
            if (err > 0) {
              callBack({
                success: false,
                STATUSCODE: 422,
                message: "Invalid verification code",
                response_data: {},
              });
            }
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found.",
              response_data: {},
            });
          }
        })
        .catch(function (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Something went wrong",
            response_data: {},
          });
        });
    }
  },
  resetPassword: (req, callBack) => {
    if (req) {
      var data = req.body;

      var userId = data.userId;

      userSchema.findOne({_id: userId}, function (err, user) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (user) {
            bcrypt.hash(data.password, 8, function (err, hash) {
              if (err) {
                callBack({
                  success: false,
                  STATUSCODE: 500,
                  message: "Something went wrong while setting the password",
                  response_data: {},
                });
              } else {
                userSchema.updateOne(
                  {_id: user._id},
                  {
                    $set: {
                      password: hash,
                    },
                  },
                  async function (err, res) {
                    if (err) {
                      callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: "Internal DB error",
                        response_data: {},
                      });
                    } else {
                      var userId = user._id;
                      var appType = data.appType;
                      var deviceToken = data.deviceToken;

                      //ADD DATA IN USER LOGIN DEVICE TABLE
                      var userDeviceData = {
                        userId: userId,
                        appType: appType,
                        deviceToken: deviceToken,
                      };

                      new userDeviceLoginSchema(userDeviceData).save(
                        async function (err, userDev) {
                          if (err) {
                            callBack({
                              success: false,
                              STATUSCODE: 500,
                              message: "Something went wrong",
                              response_data: {},
                            });
                          } else {
                            var loginId = userDev._id;
                            const authToken = generateToken(user);

                            let response = {
                              userDetails: {
                                fullName: user.fullName,
                                email: user.email,
                                countryCode: user.countryCode,
                                phone: "0",
                                userId: user._id,
                                loginId: loginId,
                                profileImage:
                                  `${config.fileUrl}profile-pic/` +
                                  user.profileImage,
                              },
                              authToken: authToken,
                            };

                            if (user.profileImage != "") {
                              response.userDetails.profileImage =
                                `${config.fileUrl}profile-pic/` +
                                user.profileImage;
                            } else {
                              response.userDetails.profileImage = "";
                            }

                            callBack({
                              success: true,
                              STATUSCODE: 200,
                              message: "Password set successfully.",
                              response_data: response,
                            });
                          }
                        }
                      );
                    }
                  }
                );
              }
            });
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found",
              response_data: {},
            });
          }
        }
      });
    }
  },

  //////////////////////////////////////////////////////////

  viewProfile: (req, callBack) => {
    if (req) {
      var data = req.body;
      userSchema.findOne({_id: data.userId}, function (err, customer) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (customer) {
            let response = {
              fullName: customer.fullName,
              email: customer.email,
              phone: customer.phone,
              gender: customer.gender,
              countryCode: customer.countryCode,
              dateOfBirth: customer.dateOfBirth,
            };

            if (customer.profileImage != "") {
              response.profileImage =
                `${config.fileUrl}profile-pic/` + customer.profileImage;
            } else {
              response.profileImage = "";
            }
            callBack({
              success: true,
              STATUSCODE: 200,
              message: "User profile fetched successfully",
              response_data: response,
            });
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found",
              response_data: {},
            });
          }
        }
      });
    }
  },
  otherProfile: async (req, callBack) => {
    if (req) {
      var data = req.body;

      var userId = data.userId;

      var notUserArr = [];

      //Check Block List
      var checkBlock = await checkblockUser(userId, data.otherUserId);

      console.log("checkBlock", checkBlock);
      if (checkBlock == false) {
        var findObj = {
          _id: data.otherUserId,
        };

        userSchema.findOne(findObj, async function (err, customer) {
          if (err) {
            callBack({
              success: false,
              STATUSCODE: 500,
              message: "Internal DB error",
              response_data: {},
            });
          } else {
            if (customer) {
              let response = {
                fullName: customer.fullName,
                email: customer.email,
                phone: customer.phone,
                gender: customer.gender,
                countryCode: customer.countryCode,
                dateOfBirth: customer.dateOfBirth,
              };

              console.log("profile image =-=-=-=-=", customer.profileImage);

              if (customer.profileImage != "") {
                if (customer.profileImage.startsWith("http")) {
                  response.profileImage = customer.profileImage;
                } else {
                  response.profileImage =
                    `${config.fileUrl}profile-pic/` + customer.profileImage;
                }
              } else {
                response.profileImage = "";
              }

              response["post"] = await getUserPostDetails(
                data.otherUserId,
                data.userId
              );

              var andReqCondObj = {};
              var reqArr = [];
              var reqCondOne = {
                $and: [
                  {fromUserId: data.userId.toString()},
                  {toUserId: data.otherUserId},
                ],
              };
              var reqCondTwo = {
                $and: [
                  {fromUserId: data.otherUserId},
                  {toUserId: data.userId.toString()},
                ],
              };

              reqArr.push(reqCondOne);
              reqArr.push(reqCondTwo);

              andReqCondObj["$or"] = reqArr;

              var mapIC = await connectedUserSchema.findOne(andReqCondObj);

              //  console.log('mapIC', mapIC);

              if (mapIC != null) {
                response["circle"] = "YES";
              } else {
                response["circle"] = "NO";
              }

              //Check Block List
              var checkMapList = await mapUserInnerCircleSchema.findOne({
                userId: userId,
                circleUserId: data.otherUserId,
              });

              if (checkMapList != null) {
                response["INNERCRCL"] = "YES";
              } else {
                response["INNERCRCL"] = "NO";
              }
              callBack({
                success: true,
                STATUSCODE: 200,
                message: "User profile fetched successfully",
                response_data: response,
              });
            } else {
              callBack({
                success: false,
                STATUSCODE: 422,
                message: "User not found",
                response_data: {},
              });
            }
          }
        });
      } else {
        callBack({
          success: false,
          STATUSCODE: 422,
          message: "You cannot able to view blocked users profile",
          response_data: {},
        });
      }
    }
  },

  updateProfile: (req, callBack) => {
    if (req) {
      var data = req.body;

      userSchema.findOne({_id: data.userId}, function (err, customer) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (customer) {
            let updateData = {
              fullName: data.fullName,
              email: data.email,
              gender: data.gender,
              countryCode: data.countryCode,
              phone: data.phone,
              relationship: data.relationship,
            };

            var date = data.dateOfBirth;
            if (date != "" && date != undefined) {
              // var dateSpl = date.split("/");
              // var month = dateSpl[1];
              // var day = dateSpl[0];
              // var year = dateSpl[2];
              // var dateNew = new Date(`${month}-${day}-${year} 00:00:00`);
              updateData["dateOfBirth"] = date;
            }

            userSchema.updateOne(
              {_id: data.userId},
              {
                $set: updateData,
              },
              function (err, res) {
                if (err) {
                  callBack({
                    success: false,
                    STATUSCODE: 500,
                    message: "Internal DB error",
                    response_data: {},
                  });
                } else {
                  if (res.nModified == 1) {
                    callBack({
                      success: true,
                      STATUSCODE: 200,
                      message: "User updated Successfully",
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
                }
              }
            );
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found",
              response_data: {},
            });
          }
        }
      });
    }
  },
  changePassword: (req, callBack) => {
    if (req) {
      var data = req.body;
      userSchema.findOne({_id: data.userId}, function (err, result) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (result) {
            const comparePass = bcrypt.compareSync(
              data.oldPassword,
              result.password
            );
            if (comparePass) {
              bcrypt.hash(data.newPassword, 8, function (err, hash) {
                if (err) {
                  callBack({
                    success: false,
                    STATUSCODE: 500,
                    message: "Something went wrong",
                    response_data: {},
                  });
                } else {
                  userSchema.updateOne(
                    {_id: data.userId},
                    {
                      $set: {
                        password: hash,
                      },
                    },
                    function (err, res) {
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
                          message: "Password updated successfully",
                          response_data: {},
                        });
                      }
                    }
                  );
                }
              });
            } else {
              callBack({
                success: false,
                STATUSCODE: 422,
                message: "Invalid old password",
                response_data: {},
              });
            }
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found",
              response_data: {},
            });
          }
        }
      });
    }
  },
  profileImageUpload: (data, callBack) => {
    if (data) {
      userSchema.findOne({_id: data.body.userId}, function (err, result) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (result) {
            if (result.profileImage != "") {
              var fs = require("fs");
              var filePath = `public/img/profile-pic/${result.profileImage}`;
              fs.unlink(filePath, (err) => {});
            }

            //Get image extension
            var ext = getExtension(data.files.image.name);

            // The name of the input field (i.e. "image") is used to retrieve the uploaded file
            let sampleFile = data.files.image;

            var file_name = `customerprofile-${Math.floor(
              Math.random() * 1000
            )}-${Math.floor(Date.now() / 1000)}.${ext}`;

            // Use the mv() method to place the file somewhere on your server
            sampleFile.mv(
              `public/img/profile-pic/${file_name}`,
              function (err) {
                if (err) {
                  callBack({
                    success: false,
                    STATUSCODE: 500,
                    message: "Internal error",
                    response_data: {},
                  });
                } else {
                  userSchema.updateOne(
                    {_id: data.body.userId},
                    {
                      $set: {profileImage: file_name},
                    },
                    function (err, res) {
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
                          message: "Profile image updated successfully",
                          response_data: {
                            profileImage:
                              `${config.fileUrl}profile-pic/` + file_name,
                          },
                        });
                      }
                    }
                  );
                }
              }
            );
          }
        }
      });
    }
  },
  logout: (req, callBack) => {
    if (req) {
      var data = req.body;
      var loginId = data.loginId;
      userDeviceLoginSchema.deleteOne({_id: loginId}, function (err) {
        if (err) {
          console.log(err);
        }
        // deleted at most one tank document
      });
      callBack({
        success: true,
        STATUSCODE: 200,
        message: "User logged out successfully",
        response_data: {},
      });
    }
  },
  searchUser: async (req, callBack) => {
    if (req) {
      var data = req.body;
      var searchVal = data.search;
      var userId = data.userId;

      var notUserArr = [userId];

      //Check Block List
      var checkBlockList = await BlockUserSchema.find({userId: userId});
      // var checkingBlock =  await BlockUserSchema.find({ blockUserId: userId });

      if (checkBlockList.length > 0) {
        for (let checkBlockUsr of checkBlockList) {
          notUserArr.push(checkBlockUsr.blockUserId);
        }
      }

      console.log("notUserArr", notUserArr);

      userSchema
        .find({
          fullName: {$regex: searchVal, $options: "i"},
          status: "ACTIVE",
          _id: {$nin: notUserArr},
          profile: {$ne: "PRIVATE"},
        })
        .then(async (searchRes) => {
          var searchArr = [];
          if (searchRes.length > 0) {
            for (let searchrs of searchRes) {
              var searchObj = {
                profileImage: searchrs.profileImage,
                fullName: searchrs.fullName,
                userId: searchrs._id,
              };

              // var andReqCondObj = {};
              // var reqArr = [];
              // var reqCondOne = { $and: [{ userId: (searchrs._id).toString() }, { circleUserId: userId }] };
              // var reqCondTwo = { $and: [{ userId: userId }, { circleUserId: (searchrs._id).toString() }] };

              // reqArr.push(reqCondOne);
              // reqArr.push(reqCondTwo);

              // andReqCondObj['$or'] = reqArr;

              // var mapIC = await mapUserInnerCircleSchema.findOne(andReqCondObj);

              var andReqCondObj = {};
              var reqArr = [];
              var reqCondOne = {
                $and: [
                  {fromUserId: searchrs._id.toString()},
                  {toUserId: userId},
                ],
              };
              var reqCondTwo = {
                $and: [
                  {fromUserId: userId},
                  {toUserId: searchrs._id.toString()},
                ],
              };

              reqArr.push(reqCondOne);
              reqArr.push(reqCondTwo);

              andReqCondObj["$or"] = reqArr;
              console.log("reqCondTwo", reqCondTwo);
              console.log("reqCondOne", reqCondOne);
              console.log("andReqCondObj", andReqCondObj);
              var mapIC = await connectedUserSchema.findOne(andReqCondObj);
              var sendInv = await sendInvitationSchema.findOne(andReqCondObj);

              // console.log('mapIC', mapIC);
              console.log("sndInv", sendInv);

              if (mapIC != null) {
                searchObj["circle"] = "YES";
                searchObj["isAccepted"] = "ACCEPTED";
              } else if (mapIC == null && sendInv != null) {
                if (sendInv.isAccepted == "YES") {
                  searchObj["circle"] = "YES";
                  // searchObj['isAccepted'] = 'ACCEPTED'
                } else {
                  searchObj["circle"] = "NO";
                  searchObj["isAccepted"] = "PENDING";
                }
              } else {
                searchObj["circle"] = "NO";
                searchObj["isAccepted"] = "RDY_TO_CONNECT";
              }
              searchArr.push(searchObj);

              console.log("searchObj", searchObj);
            }
          }

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "Search result",
            response_data: {
              data: searchArr,
              userImageUrl: `${config.serverhost}:${config.port}/img/profile-pic/`,
            },
          });
        })
        .catch((err) => {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        });
    }
  },
  getUser: (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;

      userSchema
        .find({
          status: "ACTIVE",
          _id: {$ne: userId},
        })
        .then(async (searchRes) => {
          var searchArr = [];
          if (searchRes.length > 0) {
            for (let searchrs of searchRes) {
              var searchObj = {
                profileImage: searchrs.profileImage,
                fullName: searchrs.fullName,
                userId: searchrs._id,
              };

              searchArr.push(searchObj);
            }
          }

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "User result",
            response_data: {
              data: searchArr,
              userImageUrl: `${config.serverhost}:${config.port}/img/profile-pic/`,
            },
          });
        })
        .catch((err) => {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        });
    }
  },
  sendInvitation: (req, callBack) => {
    if (req) {
      console.log(1);
      var data = req.body;
      var userId = data.userId;

      userSchema
        .findOne({
          status: "ACTIVE",
          _id: userId,
        })
        .then(async (userData) => {
          if (userData != null) {
            var userId = data.userId;
            var toUserId = data.toUserId;

            var andReqCondObj = {};
            var reqArr = [];
            var reqCondOne = {
              $and: [{fromUserId: userId}, {toUserId: toUserId}],
            };
            var reqCondTwo = {
              $and: [{fromUserId: toUserId}, {toUserId: userId}],
            };

            reqArr.push(reqCondOne);
            reqArr.push(reqCondTwo);

            andReqCondObj["$or"] = reqArr;

            console.log("reqCont", reqCondOne, reqCondTwo);

            sendInvitationSchema
              .findOne({fromUserId: data.userId, toUserId: data.userId})
              .then(async (sendReq) => {
                if (sendReq == null) {
                  console.log("sendReq ===", sendReq);
                  var sendReqObj = {
                    fromUserId: userId,
                    toUserId: toUserId,
                    sendOn: new Date(),
                    isAccepted: "NO",
                    acceptedOn: new Date(),
                    acceptReject: "ACCEPT",
                  };

                  new sendInvitationSchema(sendReqObj).save(async function (
                    err,
                    result
                  ) {
                    if (err) {
                      console.log("err", err);
                      callBack({
                        success: false,
                        STATUSCODE: 422,
                        message: "Something went wrong.",
                        response_data: {},
                      });
                    } else {
                      var userObj = await userSchema.findOne({_id: userId});
                      var notificationObj = {
                        userId: toUserId,
                        notificationType: "REQUEST_RECEIVE",
                        title: userObj.fullName,
                        message: `${userObj.fullName} send a request`,
                        isRead: "NO",
                        otherData: userId,
                      };

                      new userNotificationSchema(notificationObj).save(
                        async function (err, not) {
                          if (err) {
                            console.log("err", err);
                            callBack({
                              success: false,
                              STATUSCODE: 422,
                              message: "Something went wrong.",
                              response_data: {},
                            });
                          } else {
                            //Push Notification

                            var pushNotObj = {
                              userId: toUserId,
                              notificationType:
                                notificationObj.notificationType,
                              message: notificationObj.message,
                              isRead: notificationObj.isRead,
                              otherData: notificationObj.otherData,
                              otherUserId: notificationObj.otherUserId,
                            };

                            sendPushNotification(toUserId, pushNotObj);

                            callBack({
                              success: true,
                              STATUSCODE: 200,
                              message: "Request send successfully.",
                              response_data: {},
                            });
                          }
                        }
                      );
                    }
                  });
                } else {
                  callBack({
                    success: true,
                    STATUSCODE: 200,
                    message: "Request send successfully.",
                    response_data: {},
                  });
                }
              })
              .catch((error) => {
                console.log("error", error);
                callBack({
                  success: false,
                  STATUSCODE: 500,
                  message: "Internal error",
                  response_data: {},
                });
              });
          }
        })
        .catch((err) => {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        });
    }
  },
  acceptRequest: (data, callBack) => {
    if (data) {
      var userId = data.body.userId;
      var toUserId = data.body.toUserId;
      var isAccept = data.body.isAccept;

      var andReqCondObj = {};
      var reqArr = [];
      var reqCondOne = {$and: [{fromUserId: userId}, {toUserId: toUserId}]};
      var reqCondTwo = {$and: [{fromUserId: toUserId}, {toUserId: userId}]};

      reqArr.push(reqCondOne);
      reqArr.push(reqCondTwo);

      andReqCondObj["$or"] = reqArr;

      sendInvitationSchema
        .findOne(andReqCondObj)
        .then(async (sendReq) => {
          console.log("REQ", sendReq);
          if (sendReq != null) {
            if (isAccept == "YES") {
              sendInvitationSchema.updateOne(
                {_id: sendReq._id},
                {
                  $set: {
                    isAccepted: "YES",
                    acceptedOn: new Date(),
                    acceptReject: "ACCEPT",
                  },
                },
                function (err, result) {
                  if (err) {
                    console.log("err", err);
                    callBack({
                      success: false,
                      STATUSCODE: 500,
                      message: "Internal error",
                      response_data: {},
                    });
                  } else {
                    var connectedUserObj = {
                      fromUserId: sendReq.fromUserId,
                      toUserId: sendReq.toUserId,
                      addedOn: new Date(),
                    };

                    new connectedUserSchema(connectedUserObj).save(
                      async function (err, result) {
                        if (err) {
                          console.log("err", err);
                          callBack({
                            success: false,
                            STATUSCODE: 422,
                            message: "Something went wrong.",
                            response_data: {},
                          });
                        } else {
                          sendInvitationSchema.deleteOne(
                            {_id: sendReq._id},
                            function (err) {}
                          );

                          userNotificationSchema.deleteOne(
                            {
                              userId: sendReq.toUserId,
                              notificationType: "REQUEST_RECEIVE",
                              otherData: sendReq.fromUserId,
                            },
                            function (err) {
                              console.log(err);
                            }
                          );

                          var likedUser = await userSchema.findOne({
                            _id: sendReq.toUserId.toString(),
                          });
                          var message = `${likedUser.fullName} accepted your request`;

                          addNotificationDataDB(
                            sendReq.fromUserId,
                            "ACCEPT_REJECT",
                            message,
                            "",
                            sendReq.toUserId
                          );

                          callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: "Request accepted successfully.",
                            response_data: {},
                          });
                        }
                      }
                    );
                  }
                }
              );
            } else {
              sendInvitationSchema.updateOne(
                {_id: sendReq._id},
                {
                  $set: {
                    isAccepted: "NO",
                    acceptedOn: new Date(),
                    acceptReject: "REJECT",
                  },
                },
                function (err, result) {
                  if (err) {
                    callBack({
                      success: false,
                      STATUSCODE: 500,
                      message: "Internal error",
                      response_data: {},
                    });
                  } else {
                    sendInvitationSchema.deleteOne(
                      {_id: sendReq._id},
                      function (err) {
                        console.log(err);
                      }
                    );
                    userNotificationSchema.deleteOne(
                      {
                        userId: sendReq.toUserId,
                        notificationType: "REQUEST_RECEIVE",
                        otherData: sendReq.fromUserId,
                      },
                      function (err) {
                        console.log(err);
                      }
                    );

                    callBack({
                      success: true,
                      STATUSCODE: 200,
                      message: "Request rejected successfully.",
                      response_data: {},
                    });
                  }
                }
              );
            }
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "Something went wrong.",
              response_data: {},
            });
          }
        })
        .catch((error) => {
          console.log("error", error);
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal error",
            response_data: {},
          });
        });
    }
  },
  fetchNotification: (data, callBack) => {
    if (data) {
      var userId = data.body.userId;

      userNotificationSchema
        .find({userId: userId})
        .sort({createdAt: "desc"})
        .then(async (userNotification) => {
          var userNotArr = [];
          if (userNotification.length > 0) {
            for (let userNot of userNotification) {
              var userNotObj = {
                userId: userNot.userId,
                notificationType: userNot.notificationType,
                title: userNot.title,
                message: userNot.message,
                otherData: userNot.otherData,
                date: userNot.createdAt,
                _id: userNot._id,
              };

              if (userNot.notificationType == "REQUEST_RECEIVE") {
                var sendUser = await userSchema.findOne({
                  _id: userNot.otherData,
                });

                if (sendUser != null) {
                  (userNotObj.sendUserEmail = sendUser.email),
                    (userNotObj.profileImage =
                      `${config.serverhost}:${config.port}/img/profile-pic/` +
                      sendUser.profileImage);
                }
              }

              userNotArr.push(userNotObj);
            }
          }
          callBack({
            success: true,
            STATUSCODE: 200,
            message: "User notification",
            response_data: {userNot: userNotArr},
          });
        })
        .catch((error) => {
          console.log("error", error);
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal error",
            response_data: {},
          });
        });
    }
  },
  deleteNotification: async (req, callBack) => {
    if (req) {
      var data = req.body;
      var userId = data.userId;
      var notId = data.notificationId;
      var otherUser;

      var notificationData = sendInvitationSchema.findOne({fromUserId: userId});
      otherUser = notificationData.otherUserId;

      if (notId != undefined && notId != "") {
        await userNotificationSchema.deleteOne(
          {_id: notId},
          async function (err, result) {
            if (err) {
              console.log(err);
            } else {
              await sendInvitationSchema.deleteOne(
                {toUserId: userId},
                function (err) {
                  if (err) {
                    console.log("err", err);
                  }
                }
              );
            }
            // deleted at most one tank document
          }
        );
      } else {
        await userNotificationSchema.deleteMany(
          {userId: userId},
          async function (err, result) {
            if (err) {
              console.log(err);
            } else {
              await sendInvitationSchema.deleteOne(
                {toUserId: userId},
                function (err) {
                  if (err) {
                    console.log("err", err);
                  }
                }
              );
            }
            // deleted at most one tank document
          }
        );
      }

      callBack({
        success: true,
        STATUSCODE: 200,
        message: "Notification deleted successfully",
        response_data: {},
      });
    }
  },
  sendMessagePost: async (req, callBack) => {
    if (req) {
      try {
        console.log("REQUEST: ", req.body);
        var checkBlock = await checkblockUser(
          req.body.userId,
          req.body.toUserId
        );
        console.log("checkBlock", checkBlock);
        if (checkBlock == false) {
          var msgData = {
            fromUserId: req.body.userId,
            toUserId: req.body.toUserId,
            message: req.body.message,
            isRead: "NO",
            combinationName: `${req.body.userId}${req.body.toUserId}`,
          };

          if (req.body.quotedMsgId) {
            msgData.quoteMsgID = req.body.quotedMsgId;
            const qMsg = await MessageSchema.findById({
              _id: req.body.quotedMsgId,
            });
            if (qMsg) {
              msgData.quoteMsg = qMsg.message;
            }
          } else {
            msgData.quoteMsgID = "";
            msgData.quoteMsg = "";
          }

          var fromUser = req.body.userId;
          var toUser = req.body.toUserId;

          var andReqCondObj = {};
          var reqArr = [];
          var reqCondOne = {$and: [{fromUserId: fromUser}, {toUserId: toUser}]};
          var reqCondTwo = {$and: [{fromUserId: toUser}, {toUserId: fromUser}]};

          reqArr.push(reqCondOne);
          reqArr.push(reqCondTwo);

          andReqCondObj["$or"] = reqArr;

          var msgDataComb = await MessageSchema.findOne(andReqCondObj).sort({
            createdAt: "asc",
          });
          if (msgDataComb != null) {
            msgData["combinationName"] = msgDataComb.combinationName;
          }

          new MessageSchema(msgData).save(async function (err, message) {
            if (err) {
              console.log("err", err);
              callBack({
                success: false,
                STATUSCODE: 500,
                message: "Internal error",
                response_data: {},
              });
            } else {
              addNotificationDataDB(
                req.body.toUserId,
                "MESSAGE",
                req.body.message,
                "",
                req.body.userId
              );
              //  addNotificationDataDB(req.body.toUserId, 'Message', req.body.message, postId, req.body.fromUserId)

              callBack({
                success: true,
                STATUSCODE: 200,
                message: "",
                response_data: {
                  message: msgData,
                },
              });
            }
          });
        } else {
          callBack({
            success: false,
            STATUSCODE: 422,
            message: "You cannot able to send message to blocked user",
            response_data: {},
          });
        }
      } catch (error) {
        console.error(error);
        callBack({
          success: false,
          STATUSCODE: 500,
          message: "Internal error",
          response_data: {},
        });
      }
    }
  },
  oneToOneMessageList: async (req, callBack) => {
    if (req) {
      try {
        var fromUser = req.body.userId;
        var toUser = req.body.toUserId;

        console.log("fromUser", fromUser);
        console.log("toUser", toUser);

        var andReqCondObj = {};
        var reqArr = [];
        var reqCondOne = {$and: [{fromUserId: fromUser}, {toUserId: toUser}]};
        var reqCondTwo = {$and: [{fromUserId: toUser}, {toUserId: fromUser}]};

        reqArr.push(reqCondOne);
        reqArr.push(reqCondTwo);

        andReqCondObj["$or"] = reqArr;

        var msgData = await MessageSchema.find(andReqCondObj)
          .populate([
            {
              path: "fromUserId",
              model: "User",
            },
            {
              path: "toUserId",
              model: "User",
            },
          ])
          .sort({createdAt: "asc"});

        var msData = [];

        // console.log("msgData == ", msgData)
        if (msgData.length > 0) {
          for (let msg of msgData) {
            if (msg.deletedBy.length > 0) {
              for (let toDelete of msg.deletedBy) {
                // console.log(toDelete, req.body.userId)
                if (toDelete != req.body.userId) {
                  // msgData.splice(msg, 1)
                  if (toDelete != msg.fromUserId._id) {
                    msData.push(msg);
                  } else {
                    continue;
                  }
                } else {
                  // console.log("else part")
                  continue;
                }
              }
            } else {
              msData.push(msg);
            }
          }
        }

        // if (group.deletedBy.length > 0) {
        //     for ( let toDelete of group.deletedBy ) {
        //         if ( toDelete != req.body.user_id  ) {
        //             console.log(toDelete)
        //             // gMsgs.splice(group, 1)
        //             msgs.push(group)
        //         }
        //     }
        // } else {
        //    msgs.push(group)
        // }

        // console.log('msgData', msData);
        callBack({
          success: true,
          STATUSCODE: 200,
          message: "",
          response_data: {message: msData},
        });
      } catch (error) {
        console.error(error);
        callBack({
          success: false,
          STATUSCODE: 500,
          message: "Internal error",
          response_data: {},
        });
      }
    }
  },
  messageList: async (req, callBack) => {
    if (req) {
      try {
        var fromUserId = req.body.userId;
        const ObjectId = require("mongoose").Types.ObjectId;

        var connectedFromUserArr = [
          {fromUserId: ObjectId(fromUserId)},
          {toUserId: ObjectId(fromUserId)},
        ];
        var connectedFromUserObj = {
          $or: connectedFromUserArr,
        };

        // console.log('connectedFromUserObj', connectedFromUserObj);

        MessageSchema.aggregate([
          {
            $match: connectedFromUserObj,
          },
          {
            $sort: {createdAt: -1},
          },
          {$group: {_id: "$combinationName", doc: {$first: "$$ROOT"}}},
          {$replaceRoot: {newRoot: "$doc"}},
          {
            $sort: {createdAt: -1},
          },
          {
            $lookup: {
              from: "users",
              localField: "fromUserId",
              foreignField: "_id",
              as: "fromuser",
            },
          },
          {
            $lookup: {
              from: "users",
              localField: "toUserId",
              foreignField: "_id",
              as: "touser",
            },
          },
        ]).then(async (msgData) => {
          var msgArr = [];
          var grpArr = [];
          var finalArr = [];
          var GrpData = await ChatSchema.find({
            users: req.body.userId,
          });
          for (let data of GrpData) {
            if (data.blockedBy != req.body.userId) {
              grpArr.push(data);
            }

            for (let grp of grpArr) {
              console.log(grp, "hrp");
              var grpImg = await groupFileSchema.findOne({groupId: grp._id});
              console.log("grpImg=== ", grpImg);
              var gImg;

              if (grpImg != null) {
                gImg = grpImg.file;
              } else {
                gImg = "";
              }

              var grpObj = {
                isGroup: grp.isGroupChat,
                groupId: grp._id,
                groupName: grp.chatName,
                groupImage: gImg,
                updatedAt: grp.updatedAt,
              };

              finalArr.push(grpObj);
            }

            // grpArr.push(grpObj);
          }
          // const unique = [...new Set(finalArr.map(item => item.groupId))];
          //

          // const unique = finalArr
          //                 .map(item => item.groupId)
          //                 .filter((value, index, self) => self.indexOf(value) === index)

          var finalArrList = Array.from(
            new Set(finalArr.map(JSON.stringify))
          ).map(JSON.parse);
          // console.log("this is unique value=====",)

          // var unique = finalArr.filter(onlyUnique);
          // console.log('grp', finalArr.length)
          if (msgData.length > 0) {
            for (let msgDt of msgData) {
              var checkBlock = await checkblockUser(
                msgDt.fromUserId,
                msgDt.toUserId
              );
              console.log("checkBlock", checkBlock);
              if (checkBlock == false) {
                var msgObj = msgDt;
                msgObj["isGroup"] = false;
                if (msgDt.fromUserId == fromUserId) {
                  if (msgDt.fromIsRead == "YES") {
                    msgObj["isRead"] = "YES";
                  } else {
                    msgObj["isRead"] = "NO";
                  }
                } else if (msgDt.toUserId == fromUserId) {
                  if (msgDt.toUserId == "YES") {
                    msgObj["isRead"] = "YES";
                  } else {
                    msgObj["isRead"] = "NO";
                  }
                }

                msgArr.push(msgObj);
              } else {
                continue;
              }
            }
          }

          // console.log("GRP", finalArr)

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "",
            response_data: {
              message: msgArr,
              group: finalArrList,
            },
          });
        });
      } catch (error) {
        console.error(error);
        callBack({
          success: false,
          STATUSCODE: 500,
          message: "Internal error",
          response_data: {},
        });
      }
    }
  },
  messageDelete: async (req, callBack) => {
    if (req) {
      try {
        var fromUser = req.body.userId;
        var toUser = req.body.toUserId;

        console.log("fromUser", fromUser);
        console.log("toUser", toUser);

        var andReqCondObj = {};
        var reqArr = [];
        var reqCondOne = {$and: [{fromUserId: fromUser}, {toUserId: toUser}]};
        var reqCondTwo = {$and: [{fromUserId: toUser}, {toUserId: fromUser}]};

        reqArr.push(reqCondOne);
        reqArr.push(reqCondTwo);

        andReqCondObj["$or"] = reqArr;

        var msgData = await MessageSchema.find(andReqCondObj)
          .populate([
            {
              path: "fromUserId",
              model: "User",
            },
            {
              path: "toUserId",
              model: "User",
            },
          ])
          .sort({createdAt: "asc"});

        console.log("msgData", msgData);
        if (msgData.length > 0) {
          for (let msg of msgData) {
            await MessageSchema.deleteOne(
              {_id: msg._id.toString()},
              function (err) {
                if (err) {
                  console.log(err);
                }
                // deleted at most one tank document
              }
            );
          }
        }

        callBack({
          success: true,
          STATUSCODE: 200,
          message: "Deleted successfully",
          response_data: {},
        });
      } catch (error) {
        console.error(error);
        callBack({
          success: false,
          STATUSCODE: 500,
          message: "Internal error",
          response_data: {},
        });
      }
    }
  },
  readMessage: async (req, callBack) => {
    if (req) {
      try {
        var fromUser = req.body.userId;
        var toUser = req.body.toUserId;

        var andReqCondObj = {};
        var reqArr = [];
        var reqCondOne = {$and: [{fromUserId: fromUser}, {toUserId: toUser}]};
        var reqCondTwo = {$and: [{fromUserId: toUser}, {toUserId: fromUser}]};

        reqArr.push(reqCondOne);
        reqArr.push(reqCondTwo);

        andReqCondObj["$or"] = reqArr;

        var msgData = await MessageSchema.find(andReqCondObj).sort({
          createdAt: "desc",
        });

        if (msgData.length > 0) {
          for (let msgDt of msgData) {
            if (msgDt.fromUserId == fromUser) {
              await MessageSchema.updateOne(
                {_id: msgDt._id.toString()},
                {
                  $set: {fromIsRead: "YES"},
                }
              );
            } else if (msgDt.toUserId == fromUser) {
              await MessageSchema.updateOne(
                {_id: msgDt._id.toString()},
                {
                  $set: {toIsRead: "YES"},
                }
              );
            }
          }
        }

        callBack({
          success: true,
          STATUSCODE: 200,
          message: "",
          response_data: {},
        });
      } catch (error) {
        console.error(error);
        callBack({
          success: false,
          STATUSCODE: 500,
          message: "Internal error",
          response_data: {},
        });
      }
    }
  },

  /** Remove single message **/

  // Remove Chat

  removeChat: async (req, callBack) => {
    console.log("called", req.body);
    const msgId = req.body.msgId;
    const fromUser = req.body.userId;

    try {
      const msgData = await MessageSchema.findOne({_id: msgId});
      if (msgData.fromUserId == fromUser) {
        console.log("inside same");
        await MessageSchema.deleteOne({_id: msgId});
      } else {
        const mData = await MessageSchema.updateOne(
          {
            $or: [{fromUserId: fromUser}, {toUserId: fromUser}],
            $and: [{_id: msgId}],
          },
          {
            $push: {
              deletedBy: fromUser,
            },
          }
        );

        callBack({
          success: true,
          STATUSCODE: 200,
          message: "",
          response_data: {
            msg: "Successfully deleted",
          },
        });
        return;
        console.log("mData:", mData);
      }
    } catch (error) {
      console.error(error);
      callBack({
        success: false,
        STATUSCODE: 500,
        message: "Internal error",
        response_data: {},
      });
    }

    // const mData = await MessageSchema.find({fromUserId: fromUser})
    // console.log('mData:' , mData);
  },

  // Edit Chat

  editChat: async (req, callBack) => {
    const {msgId, message} = req.body;

    console.log("BODY", msgId);

    try {
      const updatedGroup = await MessageSchema.findByIdAndUpdate(msgId, {
        message: message,
      });
      callBack({
        success: true,
        STATUSCODE: 200,
        message: "",
        response_data: {
          message: "Editted successfully",
        },
      });
    } catch (error) {
      callBack({
        success: false,
        STATUSCODE: 400,
        message: "Internal error",
        response_data: {},
      });
    }
  },

  /** Group Chat **/

  // Create Group Chat

  createGroupChat: async (req, callBack) => {
    var users = req.body.users;
    users.push(req.body.userId);
    if (users.length < 2) {
      return callBack({
        success: false,
        STATUSCODE: 500,
        message: "Internal error",
        response_data: {
          msg: "Atleast one member have to be added",
        },
      });
    }

    try {
      const grpData = await ChatSchema.findOne({chatName: req.body.chatName});
      console.log("DATA", grpData);

      if (grpData) {
        if (grpData.chatName === req.body.chatName) {
          callBack({
            success: false,
            STATUSCODE: 400,
            message: "Group Name must be Unique",
            groupId: "",
          });
        } else {
          const groupChat = ChatSchema.create({
            chatName: req.body.chatName,
            users: users,
            isGroupChat: true,
            groupAdmin: req.body.userId,
          }).then(async (data, err) => {
            if (err) {
              console.log("Error", err);
            } else {
              callBack({
                success: true,
                STATUSCODE: 200,
                message: "Group crested successfully",
                groupId: data._id,
              });
            }
          });
        }
      } else {
        const groupChat = await ChatSchema.create({
          chatName: req.body.chatName,
          users: users,
          isGroupChat: true,
          groupAdmin: req.body.userId,
        }).then(async (data, err) => {
          if (err) {
            console.log("Error", err);
          } else {
            callBack({
              success: true,
              STATUSCODE: 200,
              message: "Group crested successfully",
              groupId: data._id,
            });
          }
        });
      }
    } catch (error) {
      console.log("ERROR", error);
      callBack({
        success: false,
        STATUSCODE: 500,
        message: "Internal error",
        response_data: {},
      });
    }
  },

  // Send message in Group

  sendMessage: async (req, callBack, next) => {
    console.log("BODY", req.body);

    var newMessage = {
      sender: req.body.sender,
      message: req.body.message,
      group_id: req.body.group_id,
    };

    if (req.body.quotedMsgId) {
      newMessage.quoteMsgID = req.body.quotedMsgId;
      const qMsg = await GroupMessageSchema.findById({
        _id: req.body.quotedMsgId,
      });
      if (qMsg) {
        newMessage.quoteMsg = qMsg.message;
      }
    } else {
      newMessage.quoteMsgID = "";
      newMessage.quoteMsg = "";
    }

    console.log("New MSG", newMessage);

    try {
      var message = await GroupMessageSchema.create(newMessage);

      console.log("MESSAGE", message);
      await ChatSchema.updateOne(
        {
          _id: req.body.group_id,
        },
        {
          $push: {
            messages: message._id,
          },
        }
      );
      callBack({
        success: true,
        STATUSCODE: 200,
        message: "",
        response_data: {
          message: "Message sent successfully",
        },
      });
    } catch (error) {
      console.log("Invalid Data", error);
      callBack({
        success: false,
        STATUSCODE: 400,
        message: "Internal error",
        response_data: {},
      });
    }
  },

  // Edit Group Chat

  editGroupChat: async (req, callBack) => {
    const {msgId, groupId, message} = req.body;

    console.log("BODY", req.body);

    try {
      const updatedGroup = await GroupMessageSchema.updateOne(
        {
          $and: [{_id: msgId}, {group_id: groupId}],
        },
        {
          message: message,
        }
      );

      console.log("DATA", updatedGroup);
      callBack({
        success: true,
        STATUSCODE: 200,
        message: "",
        response_data: {
          message: "Editted successfully",
        },
      });
    } catch (error) {
      callBack({
        success: false,
        STATUSCODE: 400,
        message: "Internal error",
        response_data: {},
      });
    }
  },

  // Rename Created Group

  renameGroup: async (req, callBack) => {
    const {group_id, groupName} = req.body;

    console.log("BODY", group_id);

    try {
      const updatedGroup = await ChatSchema.findByIdAndUpdate(group_id, {
        chatName: groupName,
      });
      callBack({
        success: true,
        STATUSCODE: 200,
        message: "",
        response_data: {
          message: "Renamed successfully",
        },
      });
    } catch (error) {
      callBack({
        success: false,
        STATUSCODE: 400,
        message: "Internal error",
        response_data: {},
      });
    }
  },

  // Remove user from Group

  removeFromGroup: async (req, callBack) => {
    const {group_id, userId} = req.body;

    // check if the requester is admin

    try {
      const removed = await ChatSchema.findByIdAndUpdate(
        {
          _id: req.body.group_id,
        },
        {
          $pull: {users: req.body.user_id},
        }
      );
      callBack({
        success: true,
        STATUSCODE: 200,
        message: "",
        response_data: {
          message: "Removed successfully",
        },
      });
    } catch (error) {
      console.log("Error", error);
      callBack({
        success: false,
        STATUSCODE: 400,
        message: "Internal Error",
        response_data: {},
      });
    }
  },

  // Add user to Group

  addToGroup: async (req, callBack) => {
    const {group_id, userId} = req.body;

    try {
      const addedUser = await ChatSchema.findByIdAndUpdate(
        {
          _id: req.body.group_id,
        },
        {
          $push: {
            users: req.body.user_id,
          },
        }
      );

      callBack({
        success: true,
        STATUSCODE: 200,
        message: "User added successfully",
        response_data: {},
      });
    } catch (error) {
      callBack({
        success: false,
        STATUSCODE: 400,
        message: "Internal Error",
        response_data: {},
      });
    }
  },

  // Get all Group Message

  getAllGroupMessage: async (req, callBack) => {
    try {
      const gMsgs = await GroupMessageSchema.find({
        group_id: req.body.group_id,
      });
      var msgs = [];
      for (let group of gMsgs) {
        if (group.deletedBy.length > 0) {
          for (let toDelete of group.deletedBy) {
            if (toDelete != req.body.user_id) {
              console.log(toDelete);
              // gMsgs.splice(group, 1)
              msgs.push(group);
            }
          }
        } else {
          msgs.push(group);
        }

        // msgs.push(group)
      }

      console.log("MSG", msgs);
      var groupMessage = [];
      for (let grpData of msgs) {
        const uData = await userSchema.find({_id: grpData.sender});
        for (let user of uData) {
          var userObj = {
            _id: user._id,
            fullName: user.fullName,
            profileImage: user.profileImage,
            message: grpData.message,
            msgId: grpData._id,
            createdAt: grpData.createdAt,
            quoteMsgID: grpData.quoteMsgID,
            quoteMsg: grpData.quoteMsg,
          };

          groupMessage.push(userObj);
        }
      }

      callBack({
        status: true,
        STATUSCODE: 200,
        message: "Data Found",
        response_data: {
          message: groupMessage,
        },
      });
    } catch (error) {
      console.log(error);
      calBack({
        status: false,
        STATUSCODE: 400,
        message: "Internal Error",
      });
    }
  },

  // Remove chat from Group

  removeChatFromGroup: async (req, callBack) => {
    console.log("BODY", req.body);

    try {
      const mData = await GroupMessageSchema.updateOne(
        {$and: [{_id: req.body.msgId}, {group_id: req.body.group_id}]},
        {
          $push: {
            deletedBy: req.body.user_id,
          },
        }
      );

      callBack({
        success: true,
        STATUSCODE: 200,
        message: "Removed Successfully",
      });
    } catch (error) {
      callBack({
        success: false,
        STATUSCODE: 422,
        message: "Internal Error",
      });
    }
  },

  // Upload Group Pic

  displayImageUpload: async (req, callBack) => {
    // console.log("FILES", req.files)

    var targetFile = req.files;
    console.log("targetFile", targetFile);
    console.log("Body", req.body);
    const s3 = new AWS.S3();
    // Binary data base64
    const fileContent = Buffer.from(targetFile.image.data, "binary");
    var ext = targetFile.image.name.slice(
      targetFile.image.name.lastIndexOf(".")
    );
    var fileName = Date.now() + ext;
    const params = {
      Bucket: "griotlegacy",
      Key: fileName, // File name you want to save as in S3
      Body: fileContent,
    };
    s3.upload(params, function (err, dataRes) {
      if (err) {
        console.log("erros", err);
      } else {
        groupFileSchema.create(
          {
            groupId: req.body.group_id,
            file: dataRes.Location,
          },
          (err, data) => {
            if (err) {
              console.log(err);
            } else {
              console.log(data);
              callBack({
                success: true,
                STATUSCODE: 200,
                message: "Uploaded Successfully",
              });
            }
          }
        );
      }
    });
  },

  // Block Group

  blockGroup: async (req, callBack) => {
    try {
      const data = await ChatSchema.updateOne(
        {
          $and: [{_id: req.body.group_id}, {users: req.body.user_id}],
        },
        {
          $push: {
            blockedBy: req.body.user_id,
          },
        }
      );

      callBack({
        success: true,
        STATUSCODE: 200,
        message: "Blocked the group successfully",
        response_data: {},
      });
    } catch (error) {
      callBack({
        success: false,
        STATUSCODE: 400,
        message: "Internal Error",
      });
    }
  },

  /** Get All Friends **/

  // Get Friend Circle

  getAllFriends: async (req, callBack) => {
    try {
      const friendsData = await connectedUserSchema.find({
        $or: [{fromUserId: req.body.user_id}, {toUserId: req.body.user_id}],
      });

      var friendsDetails = [];
      var Users = [];
      for (let friend of friendsData) {
        if (friend.fromUserId == req.body.user_id) {
          var toUser = await userSchema.find({_id: friend.toUserId});
          for (let user of toUser) {
            var userObj = {
              userId: user._id,
              userName: user.fullName,
              profileImage: user.profileImage,
              gender: user.gender,
            };

            friendsDetails.push(userObj);
          }
        } else if (friend.toUserId == req.body.user_id) {
          var fromUser = await userSchema.find({_id: friend.fromUserId});
          for (let user of fromUser) {
            var userObj = {
              userId: user._id,
              userName: user.fullName,
              profileImage: user.profileImage,
              gender: user.gender,
            };

            friendsDetails.push(userObj);
          }
        }
      }
      console.log("DATA", friendsDetails);

      callBack({
        status: true,
        STATUSCODE: 200,
        message: "Data Found",
        response_data: {
          data: friendsDetails,
        },
      });
    } catch (error) {
      console.log(error);
      callBack({
        success: false,
        STATUSCODE: 400,
        message: "Internal Error",
        response_data: {},
      });
    }
  },

  updateSettings: (req, callBack) => {
    if (req) {
      var data = req.body;

      userSchema.findOne({_id: data.userId}, function (err, customer) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (customer) {
            let updateData = {
              notification: data.notification,
              profile: data.profile,
            };

            userSchema.updateOne(
              {_id: data.userId},
              {
                $set: updateData,
              },
              function (err, res) {
                if (err) {
                  callBack({
                    success: false,
                    STATUSCODE: 500,
                    message: "Internal DB error",
                    response_data: {},
                  });
                } else {
                  if (res.nModified == 1) {
                    callBack({
                      success: true,
                      STATUSCODE: 200,
                      message: "User updated Successfully",
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
                }
              }
            );
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found",
              response_data: {},
            });
          }
        }
      });
    }
  },
  getSettings: (req, callBack) => {
    if (req) {
      var data = req.body;
      userSchema.findOne({_id: data.userId}, function (err, customer) {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 500,
            message: "Internal DB error",
            response_data: {},
          });
        } else {
          if (customer) {
            let response = {
              profile: customer.profile,
              notification: customer.notification,
            };

            callBack({
              success: true,
              STATUSCODE: 200,
              message: "User settings fetched successfully",
              response_data: response,
            });
          } else {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "User not found",
              response_data: {},
            });
          }
        }
      });
    }
  },
  deleteAccount: async (req, callBack) => {
    if (req) {
      var data = req.body;
      await userSchema.findOne({_id: data.userId}).then(async (userData) => {
        if (userData) {
          await appUsageSchema.deleteMany(
            {customerId: data.userId},
            (err, result) => {
              if (err) {
                console.log("error in appUsage", err);
              } else {
                console.log("deleted from appUsageSchema");
              }
            }
          );

          await userDeviceLoginSchema.deleteMany(
            {userId: data.userId},
            (err, result) => {
              if (err) {
                console.log("error in delive login", err);
              } else {
                console.log("deleted deviceLoginSchema");
              }
            }
          );

          await mapUserInnerCircleSchema
            .findOne({userId: data.userId})
            .then(async (mapIc) => {
              if (mapIc) {
                await mapUserInnerCircleSchema.deleteMany(
                  {userId: data.userId},
                  (err, result) => {
                    if (err) {
                      console.log("error in mapIc", err);
                    } else {
                      console.log("deleted from mapIc");
                    }
                  }
                );
              } else {
                console.log("nothing");
              }
            });
          // console.log("deleted from mapIC")

          await mapUserTribeSchema
            .findOne({userId: data.userId})
            .then(async (mapTr) => {
              if (mapTr) {
                await mapUserTribeSchema.deleteMany(
                  {userId: data.userId},
                  (err, result) => {
                    if (err) {
                      console.log("error in mapTr", err);
                    } else {
                      console.log("deleted from maptr");
                    }
                  }
                );
              } else {
                console.log("nothing");
              }
            });
          // console.log("deleted from mapTr")

          var sendInvCond = {
            $or: [{toUserId: data.userId}, {fromUserId: data.userId}],
          };

          await sendInvitationSchema.deleteMany(sendInvCond, (err, result) => {
            if (err) {
              console.log("error in sendInv", err);
            } else {
              console.log("deleted from sendInv");
            }
          });
          // console.log("deleted from sendInv")

          await userNotificationSchema.deleteMany(
            {userId: data.userId},
            (err, result) => {
              if (err) {
                console.log("error in noti", err);
              } else {
                console.log("deleted from noti");
              }
            }
          );
          // console.log("deleted from noti")

          var connectedUserCond = {
            $or: [{toUserId: data.userId}, {fromUserId: data.userId}],
          };

          await connectedUserSchema.deleteMany(
            connectedUserCond,
            (err, result) => {
              if (err) {
                console.log("error in conn", err);
              } else {
                console.log("deleted from conn");
              }
            }
          );
          // console.log("deleted from connectedUser")

          await userPostSchema
            .find({userId: data.userId})
            .then(async (userPosts) => {
              if (userPosts.length > 0) {
                await userPostSchema.deleteMany(
                  {userId: data.userId},
                  (err, result) => {
                    if (err) {
                      console.log("error in post", err);
                    } else {
                      console.log("deleted from post");
                    }
                  }
                );
              } else {
                console.log("nothing");
              }
            });
          // console.log("deleted from postSchema")

          await userFileSchema
            .find({userId: data.userId})
            .then(async (userFiles) => {
              if (userFiles.length > 0) {
                await userFileSchema.deleteMany(
                  {userId: data.userId},
                  (err, result) => {
                    if (err) {
                      console.log("error in files", err);
                    } else {
                      console.log("deleted from files");
                    }
                  }
                );
              } else {
                console.log("nothing");
              }
            });
          // console.log("deleted from fileSchema")

          var messageCond = {
            $or: [{toUserId: data.userId}, {fromUserId: data.userId}],
          };

          await MessageSchema.find(messageCond).then(async (messages) => {
            if (messages.lengh > 0) {
              await MessageSchema.deleteMany(messageCond, (err, result) => {
                if (err) {
                  console.log("error in msg", err);
                } else {
                  console.log("deleted from msg");
                }
              });
            } else {
              console.log("nothing");
            }
          });
          // console.log("deleted from message")

          // deletion from group chat in case of user is admin
          await ChatSchema.find({groupAdmin: data.userId}).then(
            async (chats) => {
              if (chats.length > 0) {
                await ChatSchema.deleteMany(
                  {groupAdmin: data.userId},
                  (err, result) => {
                    if (err) {
                      console.log("error in chat", err);
                    } else {
                      console.log("deleted from chat");
                    }
                  }
                );
              } else {
                console.log("nothing");
              }
            }
          );
          // console.log("deleted from group chat")

          // deletion from group chat in case user is a regular member
          // await ChatSchema.find({})
          //     .then(async (allChats) => {
          //         for (let chat of allChats) {
          //             if (chat.users) {
          //                 var grpUsers = chat.users
          //                 for (let user of grpUsers) {
          //                     if (user == data.userId) {
          //                         const index = grpUsers.indexOf(user)
          //                         grpUsers.splice(index, 1)

          //                         await ChatSchema.updateOne({})
          //                     }
          //                 }
          //             }
          //         }
          //     })
          await userSchema.deleteOne({_id: data.userId}, (err, result) => {
            if (err) {
              console.log("error in user", err);
            } else {
              console.log("deleted from user");
            }
          });
          // console.log("deleted from userSchema")

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "User Deleted Successfully",
            response_data: {},
          });
        } else {
          callBack({
            success: false,
            STATUSCODE: 400,
            message: "NO USER FOUND",
            response_data: {},
          });
        }
      });
    }
  },

  reportPost: async (req, callBack) => {
    if (req) {
      var data = req.body;

      var postDetails = await userPostSchema.findOne({_id: data.postId});

      var newCount = Number(postDetails.reportCount) + 1;

      await userPostSchema.updateOne(
        {_id: data.postId},
        {reportCount: newCount},
        async (err, results) => {
          if (err) {
            callBack({
              success: false,
              STATUSCODE: 422,
              message: "Internal Db error",
              response_Data: {},
            });
          } else {
            var report = await userPostSchema.findOne(
              {_id: data.postId},
              {reportCount: 1, _id: 0}
            );

            if (report.reportCount > 3) {
              await userPostSchema.deleteOne(
                {_id: data.postId},
                async (err, results) => {
                  if (err) {
                    callBack({
                      success: false,
                      STATUSCODE: 400,
                      message: "Something went wrong",
                      response_Data: {},
                    });
                    return;
                  } else {
                    // await userFileSchema.deleteMany({ postId: data.postId })

                    var notificationObj = {
                      userId: postDetails.userId,
                      notificationType: "DELETE_POST",
                      title: "Your Post Has been Deleted",
                      message:
                        "Your post has been deleted because it received multiple reports and it goes against our guidelines",
                      isRead: "NO",
                    };

                    new userNotificationSchema(notificationObj).save(
                      async function (err, not) {
                        if (err) {
                          console.log("err");
                        } else {
                          console.log("saved");
                        }
                      }
                    );
                  }
                }
              );
            } else {
              var notificationObj = {
                userId: postDetails.userId,
                notificationType: "REPORT_POST",
                title: "Warning!",
                message: "Your Post has been reported",
                isRead: "NO",
              };

              new userNotificationSchema(notificationObj).save(async function (
                err,
                not
              ) {
                if (err) {
                  console.log(err);
                  callBack({
                    success: false,
                    STATUSCODE: 422,
                    message: "Something Went wrong",
                    response_data: {},
                  });
                } else {
                  console.log("not ==", not);
                  // push notification to the owner of the post
                  var pushNotObj = {
                    userId: postDetails.userId,
                    notificationType: notificationObj.notificationType,
                    message: notificationObj.message,
                    isRead: notificationObj.isRead,
                    otherData: "",
                    otherUserId: "",
                  };

                  // sendPushNotification(postDetails.userId, pushNotObj);
                }
              });
            }
            callBack({
              success: true,
              STATUSCODE: 200,
              message: "Post has been reported",
              response_Data: {},
            });
          }
        }
      );
    }
  },

  reportUser: async (req, callBack) => {
    if (req) {
      var data = req.body;
      var reportObj = {};

      var postDetails = await userPostSchema.findOne({_id: data.postId});

      var reportedUser = postDetails.userId;

      reportObj.postId = data.postId;
      reportObj.userId = data.userId;
      reportObj.reportedUserId = reportedUser;
      reportObj.reportReason = data.reportReason;

      new reportUserSchema(reportObj).save(async (err, result) => {
        if (err) {
          callBack({
            success: false,
            STATUSCODE: 422,
            message: "Internal DB error",
            response_data: {},
          });
          return;
        } else {
          var countReports = await reportUserSchema.countDocuments({
            reportedUserId: reportedUser,
          });

          if (countReports > 5) {
            try {
              user = await userSchema.findOne({_id: reportedUser});
              mail("sendDeleteAccountMail")(user.email, user).send();
            } catch (Error) {
              console.log(Error);
            }

            await userSchema.deleteOne(
              {_id: reportedUser},
              async (req, result) => {
                if (err) {
                  callBack({
                    success: false,
                    STATUSCODE: 422,
                    message: "Internal DB error",
                    response_data: {},
                  });
                  return;
                } else {
                  console.log("deleted");
                }
              }
            );
          } else if (countReports < 5) {
            var notificationObj = {
              userId: reportedUser,
              notificationType: "REPORT_USER",
              title: "Warning!",
              message: "Your account has been reported",
              isRead: "NO",
            };

            new userNotificationSchema(notificationObj).save(
              async (err, not) => {
                if (err) {
                  console.log(err);
                  callBack({
                    success: false,
                    STATUSCODE: 422,
                    message: "Something Went Wrong",
                    response_data: {},
                  });
                  return;
                } else {
                  console.log("not == ", not);
                }
              }
            );
          }

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "User has been reported",
            response_data: result,
          });
        }
      });
    }
  },

  trackStorage: async (data, callback) => {
    if (data) {
      try {
        const userId = data.userId;

        const userData = await userSchema.findOne({_id: userId});

        if (!userData) {
          callback({
            success: false,
            STATUSCODE: 400,
            message: "No User Found",
            response_data: {},
          });
          return;
        } else {
          const userFolder = `${data.userId}/`;

          // get the objects in the user's s3 folder
          const listObjectsParams = {
            Bucket: "griotlegacyuser",
            Prefix: userFolder,
          };

          const headObjectParams = {
            Bucket: "griotlegacyuser",
            Key: userFolder,
          };

          // console.log("HEAD :", headObjectParams)
          const {Metadata} = await s3.headObject(headObjectParams).promise();

          const s3Objects = await s3.listObjectsV2(listObjectsParams).promise();

          console.log("s3Objects :", Metadata);

          var storageSizeLimit = Metadata["x-amz-meta-storage-size-limit"];
          if (!storageSizeLimit) {
            callback({
              success: false,
              STATUSCODE: 400,
              message: "Storage size limit not found",
              response_data: {},
            });
            return;
          }
          // calculate storage usage
          let totalStorageUsed = 0;
          let photoStorageUsed = 0;
          let videoStorageUsed = 0;

          s3Objects.Contents.forEach((object) => {
            totalStorageUsed += object.Size;

            // Get the file extension from the object key
            const fileExtension = object.Key.split(".").pop().toLowerCase();

            if (
              fileExtension === "jpg" ||
              fileExtension === "png" ||
              fileExtension === "jpeg"
            ) {
              photoStorageUsed += object.Size;
            } else if (fileExtension === "mp4" || fileExtension === "mkv") {
              videoStorageUsed += object.Size;
            }
          });

          // Calculate the available storage
          storageSizeLimit = parseInt(storageSizeLimit); // 2 GB limit
          const availableStorage = storageSizeLimit - totalStorageUsed;
          const usedStoragePercentage =
            (totalStorageUsed / storageSizeLimit) * 100;

          // Convert the sizes to human-readable format (e.g., bytes, KB, MB, GB)
          const formatSize = (size) => {
            if (size < 1024 * 1024 * 1024) {
              // Convert to MB if size is less than 1 GB
              return `${(size / (1024 * 1024)).toFixed(2)} MB`;
            } else {
              // Convert to GB if size is 1 GB or more
              return `${(size / (1024 * 1024 * 1024)).toFixed(2)} GB`;
            }
          };

          var videoPercentage = (videoStorageUsed / storageSizeLimit) * 100;
          var photoPercentage = (photoStorageUsed / storageSizeLimit) * 100;
          const storageUsage = {
            totalStorage: formatSize(storageSizeLimit),
            availableStorage: formatSize(availableStorage),
            usedStoragePercentage: usedStoragePercentage.toFixed(2),
            usedPercentage: (usedStoragePercentage / 100).toFixed(2),
            totalStorageUsed: formatSize(totalStorageUsed),
            photoStorageUsed: formatSize(photoStorageUsed),
            videoStorageUsed: formatSize(videoStorageUsed),
            videoPercentage: videoPercentage.toFixed(2),
            photoPercentage: photoPercentage.toFixed(2),
          };

          // Define the storage threshold values for alerts
          const almostFullThreshold = 0.9; // 90%
          const fullThreshold = 1.0; // 100%

          // Check if the storage is almost full
          if (availableStorage / storageSizeLimit <= almostFullThreshold) {
            callback({
              success: true,
              STATUSCODE: 200,
              message: "Your storage is almost full",
              response_data: storageUsage,
            });
            return;
          } else if (availableStorage <= 0) {
            callback({
              success: true,
              STATUSCODE: 200,
              message:
                "Your legacy needs more space. Buy additional storage below to keep building",
              response_data: storageUsage,
            });
            return;
          } else {
            callback({
              success: true,
              STATUSCODE: 200,
              message: "Storage fetched successfully",
              response_data: storageUsage,
            });
          }
        }
      } catch (err) {
        console.log("catch err :", err);
        const storageUsage = {
          totalStorage: "0.00",
          availableStorage: "0.00",
          usedStoragePercentage: "0.00",
          usedPercentage: "0.00",
          totalStorageUsed: "0.00",
          photoStorageUsed: "0.00",
          videoStorageUsed: "0.00",
          videoPercentage: "0.00",
          photoPercentage: "0.00",
        };
        callback({
          success: true,
          STATUSCODE: 200,
          message: "No dedicated storage found",
          response_data: storageUsage,
        });
      }
    } else {
      callback({
        success: false,
        STATUSCODE: 400,
        message: "Please enter valid data",
        response_data: {},
      });
    }
  },

  getStoragePacks: async (data, callback) => {
    try {
      var storagePackageData = await packageSchema.find({});

      if (storagePackageData.length > 0) {
        callback({
          success: true,
          STATUSCODE: 200,
          message: "All packages",
          response_data: storagePackageData,
        });
      } else {
        callback({
          success: false,
          STATUSCODE: 400,
          message: "No package found",
          response_data: [],
        });
      }
    } catch (err) {
      console.log("<<<catch err>>>", err);
      callback({
        success: false,
        STATUSCODE: 400,
        message: "Something went wrong",
        response_data: [],
      });
    }
  },
};

function generateToken(userData) {
  let payload = {subject: userData._id, user: "CUSTOMER"};
  return jwt.sign(payload, config.secretKey, {expiresIn: "3600000h"});
}

function getExtension(filename) {
  return filename.substring(filename.indexOf(".") + 1);
}

function sendVerificationCode(customer) {
  return new Promise(async function (resolve, reject) {
    let otp = Math.random().toString().replace("0.", "").substr(0, 6);
    customer = customer.toObject();
    customer.otp = otp;
    try {
      mail("sendOTPdMail")(customer.email, customer).send();
      var resp = {
        otp: otp,
      };

      await userSchema.updateOne(
        {_id: customer._id},
        {$set: {verificationOTP: otp}}
      );

      return resolve(resp);
    } catch (Error) {
      return reject();
    }
  });
}

function sendSMS(countryCode, phone) {
  return new Promise(function (resolve, reject) {
    var twilioMode = config.twilio.testMode;
    if (twilioMode == "YES") {
      var resp = {
        serviceSid: "1234",
      };
      return resolve(resp);
    } else {
      //Twilio

      const accountSid = config.twilio.TWILIO_SID;
      const authToken = config.twilio.TWILIO_AUTHTOKEN;

      var frndlyName = config.twilio.friendlyName;

      const client = require("twilio")(accountSid, authToken);

      client.verify.services
        .create({friendlyName: frndlyName})
        .then(function (service) {
          var sid = service.sid;
          var phoneNo = `${countryCode}${phone}`;

          client.verify
            .services(sid)
            .verifications.create({to: phoneNo, channel: "sms"})
            .then(function (verification) {
              if (verification.status == "pending") {
                return resolve(verification);
              } else {
                return reject(verification);
              }
            })
            .catch(function (err) {
              return reject(err);
            });
        })
        .catch(function (err) {
          return reject(err);
        });
    }
  });
}

function getUserPostDetails(userId, user) {
  return new Promise(async function (resolve, reject) {
    var userPost = await userPostSchema
      .find({userId: userId})
      .populate([
        {
          path: "comments",
          select: "comment created_At",
          model: "Comment",
          populate: {
            path: "commentedBy",
            model: "User",
            select: "userName fullName email profileImage",
          },
        },
        {
          path: "likes",
          select: " created_At",
          model: "Like",
          populate: {
            path: "likedBy",
            model: "User",
            select: "userName fullName email profileImage",
          },
        },
      ])
      .sort({createdAt: "desc"});

    var userPostArr = [];
    var userPostObj = {};
    console.log("userPost", userPost);
    if (userPost.length > 0) {
      for (let userPst of userPost) {
        if (userPst.audience === "JUSTME") {
          continue;
        } else if (userPst.audience === "TRIBE") {
          var tribeUserDetails = await mapUserTribeSchema.find({
            tribeId: userPst.tribe,
          });

          if (tribeUserDetails.length > 0) {
            for (let tribeUser of tribeUserDetails) {
              if (tribeUser.userId === user) {
                var userID = userPst.userId.toString();
                var userProf = await userSchema.findOne({_id: userID});
                userPostObj = {
                  userId: userPst.userId,
                  postId: userPst._id.toString(),
                  name: userProf.fullName,
                  caption: userPst.caption,
                  postDate: userPst.createdAt,
                  like: userPst.likes,
                  comment: userPst.comments,
                  isBlocked: userPst.isBlocked,
                  audience: userPst.audience,
                };
              } else {
                continue;
              }
            }
          } else {
            continue;
          }
        } else if (userPst.audience === "VILLAGE") {
          var userID = userPst.userId.toString();
          var userProf = await userSchema.findOne({_id: userID});
          userPostObj = {
            userId: userPst.userId,
            postId: userPst._id.toString(),
            name: userProf.fullName,
            caption: userPst.caption,
            postDate: userPst.createdAt,
            like: userPst.likes,
            comment: userPst.comments,
            isBlocked: userPst.isBlocked,
            audience: userPst.audience,
          };
        }
        // console.log("<<<<<< new USerPSt >>>>>>", userPst)

        var postId = userPst._id.toString();

        var userImageArr = await userFileSchema
          .find({userId: userID, postId: postId})
          .sort({arrange: "asc"});
        var userImgArr = [];
        if (userImageArr.length > 0) {
          for (let userImage of userImageArr) {
            if (
              userImage.file != "" ||
              userImage.file != null ||
              userImage.file != undefined
            ) {
              if (userImage.file.startsWith("http")) {
                // console.log("image ", userImage.file)
                var image_file = userImage.file;
              } else {
                var image_file = `${config.serverhost}:${config.port}/img/post/${userImage.file}`;
              }
            } else {
              var image_file = "";
            }
            // console.log(typeof(''))
            if (userImage.thumb != "") {
              if (userImage.thumb.startsWith("http")) {
                // console.log("thumb ", userImage.thumb)
                var thumb_file = userImage.thumb;
              } else {
                var thumb_file = `${config.serverhost}:${config.port}/img/post/${userImage.thumb}`;
              }
            } else {
              var thumb_file = "";
            }

            userImgArr.push({
              image: image_file,
              type: userImage.type,
              album: userImage.album,
              thumb: thumb_file,
            });
          }
          userPostObj.imageArr = userImgArr;
          userPostObj.album = userImageArr[0].album;
        } else {
          continue;
        }
        userPostArr.push(userPostObj);
      }
    }

    console.log("<<<< post arr >>>>>", userPostArr);
    console.log("<<<< array length >>>>", userPostArr.length);

    return resolve(userPostArr);
  });
}

function sendPushNotification(receiverId, notificationObj) {
  console.log(2);
  console.log("from function == ", receiverId, notificationObj);
  var gcm = require("node-gcm");
  var pushMessage = notificationObj.message;
  var badgeCount = 0;

  var sender = new gcm.Sender(config.pushAPIKey);
  userDeviceLoginSchema.find({userId: receiverId}).then(function (customers) {
    console.log(3);
    console.log("customers", customers);
    var regTokens = [];
    if (customers.length > 0) {
      for (let customer of customers) {
        console.log(4);

        var deviceToken = customer.deviceToken;

        //ANDROID PUSH START
        var andPushData = {
          badge: badgeCount,
          alert: pushMessage,
          deviceToken: deviceToken,
          dataset: notificationObj,
        };

        console.log("andPushData", andPushData);

        // Set up the sender with your GCM/FCM API key (declare this once for multiple messages)
        // var sender = new gcm.Sender(config.pushAPIKey);

        // Prepare a message to be sent
        var message = new gcm.Message({
          data: {
            sound: "default",
            alert: andPushData.dataset,
            message: andPushData.alert,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          notification: {
            title: "Griot legacy",
            icon: "ic_launcher",
            body: pushMessage,
          },
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
        console.log("length=====", andPushData.deviceToken.length);
        if (andPushData.deviceToken.length > 10) {
          console.log(5);
          regTokens.push(andPushData.deviceToken);
        }
        // Actually send the message

        //ANDROID PUSH END
      }
    } else {
      console.log("nothing");
    }

    console.log("regTokens", regTokens);
    console.log("message", message);
    sender.send(
      message,
      {registrationTokens: regTokens},
      function (err, response) {
        if (err) console.error("ggg===", err);
        else console.log("999===", response);
      }
    );
  });
}

async function addNotificationDataDB(
  userId,
  notificationType,
  message,
  otherData,
  otherUserId
) {
  //Check Settings
  var notSettings = await checkNotificationSettings(userId);

  var notificationObj = {
    userId: userId,
    notificationType: notificationType,
    title: "",
    message: message,
    isRead: "NO",
    otherData: otherData,
    otherUserId: otherUserId,
  };

  console.log("notSettings", notSettings);
  if (notSettings == true) {
    var getCount = await userSchema.findOne({_id: userId.toString()});

    console.log("getCount", getCount);
    var newNotCount = Number(getCount.notificationCount) + 1;
    var pushNotObj = {
      userId: notificationObj.userId,
      notificationType: notificationObj.notificationType,
      message: notificationObj.message,
      isRead: notificationObj.isRead,
      otherData: notificationObj.otherData,
      otherUserId: notificationObj.otherUserId,
      count: newNotCount,
    };

    await userSchema.updateOne(
      {_id: userId.toString()},
      {
        $set: {notificationCount: newNotCount},
      }
    );

    sendPushNotification(userId, pushNotObj);
  }

  new userNotificationSchema(notificationObj).save(async function (
    err,
    notification
  ) {
    if (err) {
      console.log("Notification error", err);
    } else {
      console.log("Notification Saved");
    }
  });
}

function checkNotificationSettings(userId) {
  return new Promise(function (resolve, reject) {
    userSchema
      .findOne({_id: userId})
      .then(async (notSetting) => {
        // console.log('notSetting',notSetting);
        if (notSetting != null) {
          if (notSetting.notification == "ON") {
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
      });
  });
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

function onlyUnique(value, index, self) {
  // return self.indexOf(value) === index;

  console.log("value===", value);
  console.log("Index===", index);
  console.log("self===", self);
}
