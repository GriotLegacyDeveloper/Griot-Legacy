var FCM = require('fcm-node');
var PUSH_CONFIG = require('../config');



module.exports = {
    sendPushDirect: function (pushData) {
        return new Promise(function (resolve, reject) {
            var fcm = new FCM(PUSH_CONFIG.SERVER_API_KEY);

            fcm.send(pushData, function (err, response) {
                if (err) {
                  //  console.log("Something has gone wrong!", err);
                    return reject(err);
                } else {

                    console.log("Successfully sent with response: ", response);
                    return resolve(true);
                }
            });


        });
    }
}