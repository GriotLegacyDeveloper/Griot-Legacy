const { SERVERURL, HOST, PORT, SERVERIMAGEPATH, SERVERIMAGEUPLOADPATH } = require('../../config/bootstrap');

var session = require('express-session');
var contactUsSchema = require('../../schema/ContactUs')


module.exports.messagesList = async (req,res)=>{

    var user = req.session.user;

    await contactUsSchema.find({})
    .sort({ createdAt: -1 })
    .then(async (messages)=>{
        res.render('content/messages.ejs',{
            messages: messages,
            user: user
        })
    })
}

module.exports.viewFullMessage = async (req,res)=>{
    var id = req.query.id
    var user = req.session.user

    console.log("this is the id======", id)

    const messageData = await contactUsSchema.findOne({"_id": id})
    console.log("this is all data=========", messageData)

    res.render('content/viewFullMessage.ejs',{
        user: user,
        data: messageData
    });
}