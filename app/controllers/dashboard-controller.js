const { SERVERURL, HOST, PORT, SERVERIMAGEPATH, SERVERIMAGEUPLOADPATH } = require('../../config/bootstrap');

var session = require('express-session');
var userSchema = require('../../schema/User')
var moment = require('moment')


module.exports.usercount = async (req, res) => {
    responseObjId = []
    responseObjCount = []


    //counting all users using countDocuments
    var allUsers = await userSchema
        .countDocuments({
            isDeleted: {
                $ne: true
            }
        })
    console.log("This is using countDocuments============", allUsers)

    // const data = await userSchema.aggregate([
    //     {
    //         $sort: {
    //             createdAt: -1
    //         }
    //     },
    //     {
    //         $match: {
    //             createdAt: {
    //                 $lte: new Date()
    //             }
    //         }
    //     }, {
    //         $group: {
    //             _id: {
    //                 "Year": { "$year": "$createdAt" },
    //                 "Month": { "$month": "$createdAt" },
    //                 "Day": { "$dayOfMonth": "$createdAt" }
    //             },
    //             count: { $sum: 1 }
    //         }
    //     }])

    const data = await userSchema.aggregate([{
        $group: {
            _id: {
                day: { $dayOfMonth: "$createdAt" },
                month: { $month: "$createdAt" },
                year: { $year: "$createdAt" }
            },
            count: { $sum: 1 },
            date: { $first: "$createdAt" }
        }
    }, {
        $project: {
            date: {
                $dateToString: { format: "%m/%d/%Y", date: "$date" }
            },
            count: 1,
            _id: 0
        }
    },
    {
        $sort: {
            date: -1
        }
    }])

    console.log("data =-=-=-=-=-=-=-=-=-", data, data.length)
    // var dateD = new Date()
    // console.log(dateD.toLocaleDateString())

    var dateArr = []
    var userCountArr = []

    for (let dte of data) {
        var date1 = new Date(dte.date)
        var date2 = new Date()

        console.log(dte.date, date1, date2)
        // var dateCount = dte._id.Day + "-" + dte._id.Month + "-" + dte._id.Year
        dateArr.push(dte.date)
        userCountArr.push(dte.count)
    }
    var new_dateArr = dateArr.slice(0, 14)
    var new_userCountArr = userCountArr.slice(0, 14)
    console.log("date == ", new_dateArr, new_dateArr.length)
    console.log("user count ==", new_userCountArr, new_userCountArr.length)
    //console.log("This json data=====", data)

    // session length count
    var user = req.session
    const date = new Date();

    // current hours
    let hours = date.getHours();
    // current minutes
    let minutes = date.getMinutes();
    console.log(hours + ":" + minutes);

    // console.log(req.session)

    res.render('content/dashboard.ejs', {
        allUsers: allUsers,
        data: data,
        dateArr: new_dateArr,
        userCountArr: new_userCountArr
    })

}

