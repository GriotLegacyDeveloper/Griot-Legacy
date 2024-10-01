const { ENVIRONMENT } = require('../config/bootstrap');
var adminSchema = require('../schema/Admin');

exports.beforeLogin = async (req, res, next) => {

    if (req.session.user) {

        if (ENVIRONMENT == 'development') {
            next();
        } else {
            console.log('dashboard');
            res.redirect('/customer/customerList');
        }
    } else {
        next();
    }

}


exports.afterLogin = async (req, res, next) => {
    if (req.session.user) {
        next();
    } else {
        if (ENVIRONMENT == 'development') {
            next();
        } else {
            console.log('no_user');
            res.redirect('/user/login');
        }

    }
}

exports.accessControl = async (req, res, next) => {
    var reqUrl = req.originalUrl;

    if (ENVIRONMENT == 'development') {
        next();
    } else {
        var userDt = req.session.user;

        var user = await adminSchema.findOne({_id: userDt._id});

        if (user.admintype == 'SUPER_ADMIN') {
            next();
        } else {



            //  console.log(user);
            var reqUrl = req.originalUrl;

            var manageAbleModuleArr = user.manageableModule;

            if (manageAbleModuleArr.length > 0) {
                var chckValid = 0;
                for (let manageAbleModule of manageAbleModuleArr) {

                    var n = reqUrl.search(manageAbleModule);

                    if (n >= 0) {
                        chckValid = 1
                    }
                }
            }

         //   console.log('chckValid', chckValid);
            if (chckValid == 1) {
                next();
            } else {
                res.redirect('/noAccess');
            }

        }
    }


}