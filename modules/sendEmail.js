var nodeMailer = require('nodemailer');
var nodeMailerSmtpTransport = require('nodemailer-smtp-transport');
var config = require('../config');
var handlebars = require('handlebars');
var fs = require('fs');
var path = require('path');

module.exports = function (emailType) {
    const emailFrom = config.emailConfig.MAIL_USERNAME;
    const emailPass = config.emailConfig.MAIL_PASS;
    const emailHost = config.emailConfig.MAIL_HOST;
    const emailPort = config.emailConfig.MAIL_PORT;

    // define mail types
    var mailDict = {
        "userRegistrationMail": {
            subject: "Welcome to Griot Legacy",
            html    : '../modules/emails/userRegistrationMail.html',
        },
        "forgotPasswordMail": {
            subject: "Forgot Password",
            html: '../modules/emails/forgotPasswordMail.html',
        },
        "sendOTPdMail": {
            subject: "OTP verification email",
            html: '../modules/emails/sendOTPdMail.html',
        },
        "sendDeleteAccountMail": {
            subject: "Your Account has been deleted",
            html: '../modules/emails/accountDeletedMail.html'
        }
    };

    const filePath = path.join(__dirname, mailDict[emailType].html);
    const source = fs.readFileSync(filePath, 'utf-8').toString();
    const template = handlebars.compile(source);


    var transporter = nodeMailer.createTransport(nodeMailerSmtpTransport({
        host: emailHost,
        port: emailPort,
        secure: true,
        debug: true,
        auth: {
            user: emailFrom,
            pass: emailPass,
        },
        maxMessages: 100,
        requireTLS: true,
    }));


    return function (to, data) {
        var self = {
            send: () => {
                var mailOption = {
                    from: `Griot Legacy <${emailFrom}>`,
                    to: to,
                    subject: mailDict[emailType].subject,
                };

                data.imageUrl = `${config.serverhost}:2109/img/email/`
                // data.imageUrl = 'https://nodeserver.mydevfactory.com:2109/img/email/'
                // data.imageUrl = '/var/www/html/nodeserver.brainiuminfotech.com/public_html/projects/debarati/subhajit/griotlegacy/service/public/img/email/'


                var emailTemp = config.emailTemplete;
                let mergedObj = { ...data, ...emailTemp };
                mailOption.html = template(mergedObj);


                transporter.sendMail(mailOption, function (error, info) {
                    if (error) {
                        console.log('error', error);
                        console.log('info', info);
                    } else {
                        console.log('Email Sent', info.response);
                    }
                });
            }
        }
        return self;
    }
}

