'use strict';
var express = require('express');
const config = require('../config');
const customerValidator = require('../middlewares/validators/customer/customer-validator');
const registerModel = require('../models/user/register-model');

const jwtTokenValidator = require('../middlewares/jwt-validation-middlewares');

var customerApi = express.Router();
customerApi.use(express.json());
customerApi.use(express.urlencoded({ extended: false }));



/** Customer registration */
customerApi.post('/register', customerValidator.customerRegister, function (req, res) {
    registerModel.register(req, function (result) {
        console.log("body")
        res.status(200).send(result);
    })
});


/** Customer Verify OTP */
customerApi.post('/customerVerifyUser', customerValidator.customerVerifyUser, function (req, res) {
    registerModel.customerVerifyUser(req, function (result) {
        res.status(200).send(result);
    })
});

/** Customer Login */
customerApi.post('/login', customerValidator.customerLogin, function (req, res) {
    registerModel.login(req, function (result) {
        res.status(200).send(result);
    })
});




/** Forgot Password */
customerApi.post('/forgotPassword', customerValidator.forgotPasswordEmail, function (req, res) {
    registerModel.forgotPassword(req, function (result) {
        res.status(200).send(result);
    })
});

/** Forgot Password */
customerApi.post('/resendOTP', customerValidator.resendOTP, function (req, res) {
    registerModel.resendOTP(req, function (result) {
        res.status(200).send(result);
    })
});

/** Forgot Password Verify OTP */
customerApi.post('/fpVerifyUser', customerValidator.fpVerifyUser, function (req, res) {
    registerModel.fpVerifyUser(req, function (result) {
        res.status(200).send(result);
    })
});

/** Reset Password */
customerApi.post('/resetPassword', customerValidator.resetPassword, function (req, res) {
    registerModel.resetPassword(req, function (result) {
        res.status(200).send(result);
    });
});


/** View Profile */
customerApi.post('/viewProfile', jwtTokenValidator.validateToken, customerValidator.viewProfile, function (req, res) {
    registerModel.viewProfile(req, function (result) {
        res.status(200).send(result);
    });
})

/** Update Profile */
customerApi.post('/updateProfile', jwtTokenValidator.validateToken, customerValidator.updateProfile, function (req, res) {
    registerModel.updateProfile(req, function (result) {
        res.status(200).send(result);
    });
})

/** Change password */
customerApi.post('/changePassword', jwtTokenValidator.validateToken, customerValidator.changePassword, function (req, res) {
    registerModel.changePassword(req, function (result) {
        res.status(200).send(result);
    });
})

/** Profile image upload */
customerApi.post('/profileImageUpload', customerValidator.profileImageUpload, function (req, res) {
    registerModel.profileImageUpload(req, function (result) {
        res.status(200).send(result);
    });
})

/** Logout */
customerApi.post('/logout', customerValidator.logout, function (req, res) {
    registerModel.logout(req, function (result) {
        res.status(200).send(result);
    });
});

/** Search */
customerApi.post('/searchUser', customerValidator.searchUser, function (req, res) {
    registerModel.searchUser(req, function (result) {
        res.status(200).send(result);
    });
})

customerApi.post('/getUser', jwtTokenValidator.validateToken, customerValidator.home, function (req, res) {
    registerModel.getUser(req, function (result) {
        res.status(200).send(result);
    });
})

customerApi.post('/sendInvitation', jwtTokenValidator.validateToken, customerValidator.sendInvitation, function (req, res) {
    console.log(100)
    registerModel.sendInvitation(req, function (result) {
        res.status(200).send(result);
    });
})

customerApi.post('/acceptRequest', jwtTokenValidator.validateToken, customerValidator.acceptRequest, function (req, res) {
    registerModel.acceptRequest(req, function (result) {
        res.status(200).send(result);
    });
})

customerApi.post('/fetchNotification', jwtTokenValidator.validateToken, customerValidator.fetchNotification, function (req, res) {
    registerModel.fetchNotification(req, function (result) {
        res.status(200).send(result);
    });
});

customerApi.post('/deleteNotification', jwtTokenValidator.validateToken, customerValidator.deleteNotification, function (req, res) {
    registerModel.deleteNotification(req, function (result) {
        res.status(200).send(result);
    });
});

/** Other Profile */
customerApi.post('/otherProfile', customerValidator.otherProfile, function (req, res) {
    registerModel.otherProfile(req, function (result) {
        res.status(200).send(result);
    });
})


/** Send Message Post */
customerApi.post('/sendMessagePost', customerValidator.sendMessagePost, function (req, res) {
    registerModel.sendMessagePost(req, function (result) {
        res.status(200).send(result);
    });
})

/** One to one message list */
customerApi.post('/oneToOneMessageList', customerValidator.oneToOneMessageList, function (req, res) {
    registerModel.oneToOneMessageList(req, function (result) {
        res.status(200).send(result);
    });
})

/** Message List */
customerApi.post('/messageList', customerValidator.messageList, function (req, res) {
    registerModel.messageList(req, function (result) {
        res.status(200).send(result);
    });
})

customerApi.post('/messageDelete', customerValidator.messageDelete, function (req, res) {
    registerModel.messageDelete(req, function (result) {
        res.status(200).send(result);
    });
})

customerApi.post('/readMessage', customerValidator.readMessage, function (req, res) {
    registerModel.readMessage(req, function (result) {
        res.status(200).send(result);
    });
})

// Remove Chat

customerApi.post('/removeChat', customerValidator.removeChat, function (req, res) {
    registerModel.removeChat(req, function (result) {
        res.status(200).send(result);
    });
})

// Edit Chat

customerApi.put('/editChat', customerValidator.editChat, function (req, res) {
    registerModel.editChat(req, function (result) {
        res.status(200).send(result);
    });
})

/** Group Chat **/

// Create Chat

customerApi.post('/createGroup', customerValidator.createGroupChat, function (req, res) {
    registerModel.createGroupChat(req, function (result) {
        res.status(200).send(result);
    });
})

// Send Message in Group

customerApi.post('/sendMessage', customerValidator.sendMessage, function (req, res) {
    registerModel.sendMessage(req, function (result) {
        res.status(200).send(result);
    });
})

// Edit Group Chat

customerApi.put('/editGroupChat', customerValidator.editGroupChat, function (req, res) {
    registerModel.editGroupChat(req, function (result) {
        res.status(200).send(result);
    });
})

// Rename Group

customerApi.put('/renameGroup', customerValidator.renameGroup, function (req, res) {
    registerModel.renameGroup(req, function (result) {
        res.status(200).send(result);
    });
})

// Remove user from Group

customerApi.post('/removeFromGroup', customerValidator.removeFromGroup, function (req, res) {
    registerModel.removeFromGroup(req, function (result) {
        res.status(200).send(result);
    });
})

// Add user to Group

customerApi.post('/addToGroup', customerValidator.addToGroup, function (req, res) {
    registerModel.addToGroup(req, function (result) {
        res.status(200).send(result);
    });
})

// Get all Group Message

customerApi.post('/getAllGroupMessage', customerValidator.getAllGroupMessage, function (req, res) {
    registerModel.getAllGroupMessage(req, function (result) {
        res.status(200).send(result);
    })
})

// Remove Chat from Group

customerApi.post('/removeChatFromGroup', customerValidator.removeChatFromGroup, function (req, res) {
    registerModel.removeChatFromGroup(req, function (result) {
        res.status(200).send(result);
    })
})

// Upload Group Pic

customerApi.post('/displayImageUpload', customerValidator.displayImageUpload, function (req, res) {
    registerModel.displayImageUpload(req, function (result) {
        res.status(200).send(result);
    })
})

// Block Group

customerApi.post('/blockGroup', customerValidator.blockGroup, function (req, res) {
    registerModel.blockGroup(req, function (result) {
        res.status(200).send(result);
    })
})

/** Get Friend Circle **/

// Get all Friends

customerApi.post('/getAllFriends', customerValidator.getAllFriends, function (req, res) {
    registerModel.getAllFriends(req, function (result) {
        res.status(200).send(result);
    });
})

/** Update Settings */
customerApi.post('/updateSettings', jwtTokenValidator.validateToken, customerValidator.updateSettings, function (req, res) {
    registerModel.updateSettings(req, function (result) {
        res.status(200).send(result);
    });
})

/** Get Settings */
customerApi.post('/getSettings', jwtTokenValidator.validateToken, customerValidator.viewProfile, function (req, res) {
    registerModel.getSettings(req, function (result) {
        res.status(200).send(result);
    });
})

// Delete Profile
customerApi.post('/deleteAccount', jwtTokenValidator.validateToken, customerValidator.deleteAccount, function (req, res) {
    registerModel.deleteAccount(req, function (result) {
        res.status(200).send(result);
    })
})

// report post
customerApi.post('/reportPost', jwtTokenValidator.validateToken, customerValidator.reportPost, function (req, res) {
    registerModel.reportPost(req, function (result) {
        res.status(200).send(result);
    })
})

// report user
customerApi.post('/reportUser', jwtTokenValidator.validateToken, customerValidator.reportUser, function (req, res) {
    registerModel.reportUser(req, function (result) {
        res.status(200).send(result);
    })
})

// track storage usage in s3
customerApi.post('/trackStorage', function (req, res) {
    registerModel.trackStorage(req.body, function (result) {
        res.status(200).send(result)
    })
})

customerApi.post('/getStoragePacks', function (req, res) {
    registerModel.getStoragePacks(req, function (result) {
        res.status(200).send(result)
    })
})




module.exports = customerApi;