var nodeMailer = require('nodemailer');
var nodeMailerSmtpTransport = require('nodemailer-smtp-transport');
const { MAIL_USERNAME, MAIL_PASS, HOST, PORT, APP_URL } = require('../config/bootstrap');
var handlebars = require('handlebars');
var fs = require('fs');
var path = require('path');

module.exports = function (emailType) {
    const emailFrom = MAIL_USERNAME;
    const emailPass = MAIL_PASS;

    // define mail types
    var mailDict = {
        "forgotPasswordEmail": {
            subject: "Forgot Password",
            html    : '../modules/emails/forgotPasswordEmail.html',
        },
        "SubadminAdd": {
            subject: "Welcome to GriotLegacy",
            html    : '../modules/emails/SubadminAdd.html',
        },
        "carrierApproval": {
            subject: "Account Approval",
            html    : '../modules/emails/carrierApproval.html',
        },
        "shipperApproval": {
            subject: "Account Approval",
            html    : '../modules/emails/shipperApproval.html',
        },
    };

    const filePath = path.join(__dirname, mailDict[emailType].html);
    const source = fs.readFileSync(filePath, 'utf-8').toString();
    const template = handlebars.compile(source);


    var transporter = nodeMailer.createTransport(nodeMailerSmtpTransport({
        host: 'smtp.gmail.com',
        port: 465,
        secure: true,
        debug: true,
        auth: {
            user: emailFrom,
            // pass    : emailPass,
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
                    // text: `Hello ${data.name}, please verify your studiolive account. Your verification code is ${data.otp}`
                };

                data.imageUrl = `${HOST}:${PORT}/img/email/`

                var emailTemp = {
                    appUrl: APP_URL
                };
                let mergedObj = {...data, ...emailTemp};
                mailOption.html = template(mergedObj);

                transporter.sendMail(mailOption, function (error, info) {
                    if (error) {
                        console.log(error);
                    } else {
                        console.log('Email Sent', info.response);
                    }
                });
            }
        }
        return self;
    }
}

