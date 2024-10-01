var joi = require('joi');

module.exports = {

    customerRegister: async (req, res, next) => {
        const genderVal = ["MALE", "FEMALE", "NON_BINARY", "PREFER_NOT_TO_REVEAL_IT"];
        const relationshipVal = ["SINGLE", "MARRIED", "RELATIONSHIP", "DIVORCED"];
        const rules = joi.object({
            fullName: joi.string().required().error(new Error('Full name is required')),
            email: joi.string().email().allow('').error(new Error('Email is required')),
            phone: joi.number().integer().optional().allow(''),
            countryCode: joi.string().optional().allow(''),
            password: joi.string().required().error(new Error('Password is required')),
            confirmPassword: joi.string().valid(joi.ref('password')).required().error(err => {
                if (err[0].value === undefined || err[0].value === '' || err[0].value === null) {
                    return new Error('Confirm password is required');
                } else if (err[0].value !== req.body.password) {
                    return new Error('Password and confirm password must match');
                }
            }),


            dateOfBirth: joi.any().allow('').optional(),
            gender: joi.string().required().valid(...genderVal).error(new Error('Gender is required')),
            // relationship: joi.string().required().valid(...relationshipVal).error(new Error('Relationship is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();

        }
    },

    customerLogin: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            user: joi.string().required().error(new Error('Email/Phone is required')),
            password: joi.string().required().error(new Error('Password is required')),
            deviceToken: joi.string().error(new Error('Device token is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    customerVerifyUser: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            deviceToken: joi.string().error(new Error('Device token is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            sid: joi.string().required().error(new Error('Sid required')),
            otp: joi.string().required().error(new Error('Otp is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    forgotPasswordEmail: async (req, res, next) => {

        const rules = joi.object({
            user: joi.string().required().error(new Error('Email/Phone is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    resendOTP: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            type: joi.string().error(new Error('Type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    fpVerifyUser: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            sid: joi.string().error(new Error('Sid required')),
            otp: joi.string().error(new Error('Otp is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    resetPassword: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            password: joi.string().required().error(new Error('Password is required')),
            confirmPassword: joi.string().valid(joi.ref('password')).required().error(err => {
                if (err[0].value === undefined || err[0].value === '' || err[0].value === null) {
                    return new Error('Confirm password is required');
                } else if (err[0].value !== req.body.password) {
                    return new Error('Password and confirm password must match');
                }
            }),
            deviceToken: joi.string().error(new Error('Device token required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },


    viewProfile: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    otherProfile: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            otherUserId: joi.string().required().error(new Error('User id is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    updateProfile: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const genderVal = ["MALE", "FEMALE", "NON_BINARY", "PREFER_NOT_TO_REVEAL_IT"];
        const relationshipVal = ["SINGLE", "MARRIED", "RELATIONSHIP", "DIVORCED"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            fullName: joi.string().required().error(new Error('Full name is required')),
            email: joi.string().email().allow('').error(new Error('Email is required')),
            phone: joi.number().integer().allow(''),
            countryCode: joi.string().allow(''),
            dateOfBirth: joi.any().allow('').optional(),
            gender: joi.string().required().valid(...genderVal).error(new Error('Gender is required')),
            relationship: joi.string().required().valid(...relationshipVal).error(new Error('Relationship is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            console.log('value.error', value.error.message);
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    changePassword: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('Customer id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            oldPassword: joi.string().required().error(new Error('Old password is required')),
            newPassword: joi.string().required().error(err => {
                if (err[0].value === undefined || err[0].value === '' || err[0].value === null) {
                    return new Error('New password is required');
                } else if (err[0].value == req.body.oldPassword) {
                    return new Error('New password and new password must not match');
                }
            }),
            confirmPassword: joi.string().valid(joi.ref('newPassword')).required().error(err => {
                if (err[0].value === undefined || err[0].value === '' || err[0].value === null) {
                    return new Error('Confirm password is required');
                } else if (err[0].value !== req.body.newPassword) {
                    return new Error('New password and confirm password must match');
                }
            })
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    profileImageUpload: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('Customer id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required'))
        });
        const imageRules = joi.object({
            image: joi.object().required().error(new Error('Image is required')),
        });

        const value = await rules.validate(req.body);
        const imagevalue = await imageRules.validate(req.files);

        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else if (imagevalue.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: 'Image is required'
            })
        } else if (!["jpg", "jpeg", "bmp", "gif", "png"].includes(getExtension(req.files.image.name))) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: 'Invalid image format.'
            })
        } else {
            next();
        }
    },
    logout: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    createPost: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const audienceVal = ['TRIBE', 'INNERCIRCLE', 'VILLAGE', 'JUSTME'];
        const postTypeVal = ['FILE', 'NORMAL', 'LINK'];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            caption: joi.string().allow(''),
            audience: joi.string().required().valid(...audienceVal).error(new Error('Audience is required')),
            postType: joi.string().required().valid(...postTypeVal).error(new Error('Post type is required')),
            album: joi.string().allow(''),
            files: joi.string().allow(''),
            tribeId: joi.string().allow(''),
        });

        console.log('req.body', req.body);

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    createAdvertisement: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            companyName: joi.string().allow(''),
            contactPerson: joi.string().required().error(new Error('contactPerson is required')),
            emailAddress: joi.string().required().error(new Error('Email address is required')),
            phoneNumber: joi.string().required().error(new Error('Phone number is required')),
            countryCode: joi.string().required().error(new Error('Country Code is required')),
            physicalAddress: joi.string().allow(''),
            purposeOfAdvertisement: joi.string().allow(''),
            image: joi.string().allow(''),
            description: joi.string().required().error(new Error('Description is required')),
            validFrom: joi.string().allow(''),
            validTill: joi.string().allow(''),
            link: joi.string().required().error(new Error('You must provide an advertisement link')),
            title: joi.string().required().error(new Error('You must provide an advertisement Title')),
            targetAudience: joi.string().optional().allow('')

        });

        // console.log('req.body', req.body);

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    updatePost: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const audienceVal = ['TRIBE', 'INNERCIRCLE', 'VILLAGE', 'JUSTME'];
        const postTypeVal = ['FILE', 'NORMAL', 'LINK'];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            caption: joi.string().allow(''),
            audience: joi.string().required().valid(...audienceVal).error(new Error('Audience is required')),
            postType: joi.string().required().valid(...postTypeVal).error(new Error('Post type is required')),
            album: joi.string().allow(''),
            files: joi.string().allow(''),
            tribeId: joi.string().allow(''),
            postId: joi.string().required().error(new Error('Post id is required')),
            fileIds: joi.string().allow('')
        });

        console.log('req.body', req.body);

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    home: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            type: joi.string().optional()
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    removePost: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            postId: joi.string().required().error(new Error('Post id is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    removeImage: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            imageId: joi.string().required().error(new Error('Image id is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    likePost: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            postId: joi.string().required().error(new Error('Post id is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    commentPost: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            postId: joi.string().required().error(new Error('Post id is required')),
            comment: joi.string().required().error(new Error('Comment is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    createTribe: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const tribeTypeVal = [];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            name: joi.string().required().error(new Error('Tribe name is required')),
            type: joi.string().required().error(new Error('Tribe type is required')),
            people: joi.string().required().error(new Error('Tribe people is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    addInnerCircleMember: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            people: joi.string().required().error(new Error('Tribe people is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    blockUser: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            blockedUserId: joi.string().required().error(new Error('Block user is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    blockUserList: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    searchUser: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            search: joi.string().error(new Error('Search text required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    leaveTribe: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            tribeId: joi.string().required().error(new Error('Tribe id is required')),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    blockTribe: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            tribeId: joi.string().required().error(new Error('Tribe id is required')),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    blockTribeList: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    sendInvitation: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            toUserId: joi.string().required().error(new Error('User id is required')),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    acceptRequest: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const isAcceptVal = ["YES", "NO"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            toUserId: joi.string().required().error(new Error('User id is required')),
            isAccept: joi.string().required().valid(...isAcceptVal).error(new Error('Accept required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    fetchNotification: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const isAcceptVal = ["YES", "NO"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    deleteNotification: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const isAcceptVal = ["YES", "NO"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required')),
            notificationId: joi.string().allow('')
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    sendMessagePost: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            toUserId: joi.string().required().error(new Error('User id is required')),
            message: joi.string().required().error(new Error('Message is required')),
            quotedMsgId: joi.string().allow(''),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    oneToOneMessageList: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            toUserId: joi.string().required().error(new Error('User id is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    messageList: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    messageDelete: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            toUserId: joi.string().required().error(new Error('User id is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    readMessage: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            toUserId: joi.string().required().error(new Error('User id is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    /** Remove Chat **/

    // remove chat
    removeChat: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            msgId: joi.string().required().error(new Error('User id is required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    // Edit Chat

    editChat: async (req, res, next) => {
        const rules = joi.object({
            msgId: joi.string().required().error(new Error('Message id is required')),
            message: joi.string().required().error(new Error('Content is required')),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    /** GROUP CHAT **/

    // Create Group

    createGroupChat: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            chatName: joi.string().required().error(new Error('Group name is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            users: joi.array().allow(),

        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    // Send Message in Group

    sendMessage: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            sender: joi.string().required().error(new Error('User id is required')),
            group_id: joi.string().required().error(new Error('User id is required')),
            message: joi.string().required().error(new Error('Message is required')),
            quotedMsgId: joi.string().allow(''),

        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    // Edit Chat

    editGroupChat: async (req, res, next) => {
        const rules = joi.object({
            msgId: joi.string().required().error(new Error('Message id is required')),
            groupId: joi.string().required().error(new Error('Group Id is required')),
            message: joi.string().required().error(new Error('Content is required')),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    // Rename Group

    renameGroup: async (req, res, next) => {
        const rules = joi.object({
            group_id: joi.string().required().error(new Error('Group id is required')),
            groupName: joi.string().required().error(new Error('Group name is required')),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    // Remove user from Group

    removeFromGroup: async (req, res, next) => {
        const rules = joi.object({
            group_id: joi.string().required().error(new Error('Group id is required')),
            user_id: joi.string().required().error(new Error('User id is required')),
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    // Add user to Group

    addToGroup: async (req, res, next) => {
        const rules = joi.object({
            group_id: joi.string().required().error(new Error('Group id is required')),
            user_id: joi.string().required().error(new Error('user id is required')),
        })

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next()
        }
    },

    // Get all Group Message

    getAllGroupMessage: async (req, res, next) => {
        const rules = joi.object({
            group_id: joi.string().required().error(new Error('Group Id is required')),
            user_id: joi.string().required().error(new Error('User Id is required'))
        })

        const value = await rules.validate(req.body);

        if (value.error) {
            req.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next()
        }
    },

    // Remove Chat from Group

    removeChatFromGroup: async (req, res, next) => {
        const rules = joi.object({
            group_id: joi.string().required().error(new Error('Group Id is required')),
            msgId: joi.string().required().error(new Error('Message Id is required')),
            user_id: joi.string().required().error(new Error('User Id is required'))
        })

        const value = await rules.validate(req.body);

        if (value.error) {
            req.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next()
        }
    },

    // Add Display Image

    displayImageUpload: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            group_id: joi.string().required().error(new Error('Group id is required')),
        });
        const imageRules = joi.object({
            image: joi.object().required().error(new Error('Image is required')),
        });

        const value = await rules.validate(req.body);
        const imagevalue = await imageRules.validate(req.files);

        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else if (imagevalue.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: 'Image is required'
            })
        } else if (!["jpg", "jpeg", "bmp", "gif", "png"].includes(getExtension(req.files.image.name))) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: 'Invalid image format.'
            })
        } else {
            next();
        }
    },

    // Block Group

    blockGroup: async (req, res, next) => {
        const rules = joi.object({
            group_id: joi.string().required().error(new Error('Group Id is required')),
            user_id: joi.string().required().error(new Error('User Id is required'))
        })

        const value = await rules.validate(req.body);

        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next()
        }
    },

    /** Get Friend Circle **/

    getAllFriends: async (req, res, next) => {
        const rules = joi.object({
            user_id: joi.string().required().error(new Error('User Id is required'))
        })

        const value = await rules.validate(req.body);

        if (value.error) {
            res.send(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next()
        }
    },

    updateSettings: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const ofOffVal = ["ON", "OFF"];
        const privPubVal = ["PUBLIC", "PRIVATE"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error('App type required')),
            notification: joi.string().required().valid(...ofOffVal).error(new Error('Notification is required')),
            profile: joi.string().required().valid(...privPubVal).error(new Error('Profile is required')),

        });

        const value = await rules.validate(req.body);
        if (value.error) {
            console.log('value.error', value.error.message);
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },
    dashboard: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User id is required')),
            loginId: joi.string().required().error(new Error('Login id is required')),
            appType: joi.string().required().valid(...appTypeVal).error(new Error('App type required'))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(200).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    deleteAccount: async (req, res, next) => {
        const appTypeVal = ["ANDROID", "IOS", "BROWSER"];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User Id is required')),
            loginId: joi.string().required().error(new Error('Login Id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error("App Type is required"))
        });

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(422).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next();
        }
    },

    reportPost: async (req, res, next) => {
        const appTypeVal = ['ANDROID', 'IOS', 'BROWSER'];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User Id is required')),
            loginId: joi.string().required().error(new Error('Login Id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error("App type is required")),
            postId: joi.string().required().error(new Error('post Id is required'))
        })

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(422).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next()
        }
    },
    reportUser: async (req, res, next) => {
        const appTypeVal = ['ANDROID', 'IOS', 'BROWSER'];
        const rules = joi.object({
            userId: joi.string().required().error(new Error('User Id is required')),
            loginId: joi.string().required().error(new Error('Login Id is required')),
            appType: joi.string().valid(...appTypeVal).error(new Error("App type is required")),
            postId: joi.string().required().error(new Error('post Id is required')),
            reportReason: joi.string().optional().allow('')
        })

        const value = await rules.validate(req.body);
        if (value.error) {
            res.status(422).json({
                success: false,
                STATUSCODE: 422,
                message: value.error.message
            })
        } else {
            next()
        }
    }
}

function getExtension(filename) {
    return filename.substring(filename.indexOf('.') + 1);
}
