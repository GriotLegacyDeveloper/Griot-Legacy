var PUSH_CONFIG = {};


//Ios [APN]
PUSH_CONFIG.IOS_PRODUCTION_MODE  = true;
PUSH_CONFIG.IOS_AUTHKEY_FILE = "AuthKey_928VKKZ26N.p8"; // When we download the key from the Apple Developer Keys page, it will have a name like AuthKey_A1BC23DE45.p8
PUSH_CONFIG.IOS_AUTHKEY_FILEPATH = "/var/www/html/nodeserver.brainiuminfotech.com/public_html/projects/debarati/subhajit/GriotLegacy/service/modules/libraries/pushlib/Ios/resource/AuthKey_928VKKZ26N.p8"; //PATH from APN
PUSH_CONFIG.IOS_KEY_ID = "928VKKZ26N"; //The A1BC23DE45 is the keyId that you need here
PUSH_CONFIG.IOS_TEAM_ID = "2H5JW86X3B"; //IDENTIFIER [developer-team-id]
PUSH_CONFIG.IOS_TOPIC = "com.Brainium.GriotLegacy"; //Your Application bundle ID

//Android [FCM]
PUSH_CONFIG.SERVER_API_KEY = '';

//Web [FCM]
PUSH_CONFIG.CLICK_LINK = ''
module.exports = PUSH_CONFIG
