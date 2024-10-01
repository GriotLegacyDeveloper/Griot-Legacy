var userSchema = require('../../schema/User')
var appUsageSchema = require('../../schema/Appusage')
var moment = require('moment')
const { Result } = require('express-validator')
// const Appusage = require('../../schema/Appusage')

module.exports = {
    appUsage: async (data, callBack) => {
        if (data) {
            // console.log(data)
            console.log
            var IN = data.body.IN
            var OUT = data.body.OUT
            var date = data.body.date
            var id = data.body.id

            await userSchema.findOne({ "_id": id })
                .then(async (result) => {
                    if (result) {
                        await appUsageSchema.findOne({ "customerId": id, "date": date })
                            .then(async (appUsageData) => {
                                if (appUsageData) {
                                    console.log("first=-=-==-=", appUsageData)
                                    if (IN && !OUT) {
                                        var today = moment()
                                        OUT = moment(today).format("HH:mm:ss")

                                        console.log("server time format == ", today, OUT)

                                        var sum = appUsage(IN, OUT, appUsageData.appUsage)

                                        await appUsageSchema.updateOne({ "customerId": id, "date": date },
                                            {
                                                // "appUsage": sum,
                                                "IN": IN,
                                                // "OUT": OUT
                                            })

                                        appUsageSchema.findOne({ "customerId": id, "date": date })
                                            .then(async (res) => {
                                                if (res) {
                                                    callBack({
                                                        success: true,
                                                        STATUSCODE: 200,
                                                        message: "APP USAGE TIME",
                                                        response_data: res
                                                    })
                                                } else {
                                                    callBack({
                                                        success: false,
                                                        STATUSCODE: 400,
                                                        message: "INTERNAL DB ERROR",
                                                        response_data: {}
                                                    })
                                                }
                                            })

                                    } else if (!IN && OUT) {
                                        await appUsageSchema.findOne({ "customerId": id, "date": date })
                                            .then(async (newUsage) => {
                                                // console.log("1234 =-=-=-=-=", OUT,newUsage.IN)
                                                var outMoment = moment(OUT, 'HH:mm:ss')
                                                var inMoment = moment(newUsage.IN, 'HH:mm:ss')
                                                var duration = outMoment.diff(inMoment)
                                                // console.log("1234 =-=-=-=-=", inMoment, outMoment, duration)

                                                if (duration < 0) {
                                                    var inTime = '00:00:00'
                                                    var sum = appUsage(inTime, OUT, '0')
                                                    var oldSum = appUsage(newUsage.IN, '23:59:59', newUsage.appUsage)

                                                    var newUsageData = await new appUsageSchema({
                                                        name: result.fullName,
                                                        email: result.email,
                                                        customerId: result._id,
                                                        date: moment().format('DD-MM-YYYY'),
                                                        IN: inTime,
                                                        OUT: OUT,
                                                        appUsage: sum
                                                    })

                                                    await newUsageData.save((err, newAppUsageData) => {
                                                        if (err) {
                                                            callBack({
                                                                success: false,
                                                                STATUSCODE: 400,
                                                                message: 'Something Went Wrong',
                                                                response_data: {}
                                                            })
                                                        } else {
                                                            newUsageData.appUsage = sum
                                                            callBack({
                                                                success: true,
                                                                STATUSCODE: 200,
                                                                message: 'APP USAGE TIME',
                                                                response_data: newAppUsageData
                                                            })
                                                        }
                                                    })


                                                    await appUsageSchema.updateOne({ "customerId": id, "date": date },
                                                        {
                                                            "appUsage": oldSum,
                                                            "OUT": '23:59:59'
                                                        }, (err, update) => {
                                                            if (err) {
                                                                console.log("err ", err)
                                                            } else {
                                                                console.log("result", update)
                                                            }
                                                        })


                                                } else {
                                                    // var outTime = '23:59:59'
                                                    var sum = appUsage(newUsage.IN, OUT, newUsage.appUsage)

                                                    await appUsageSchema.updateOne({ "customerId": id, "date": date },
                                                        {
                                                            "appUsage": sum,
                                                            "OUT": OUT
                                                        }, (err, update) => {
                                                            if (err) {
                                                                console.log("err ", err)
                                                            } else {
                                                                console.log("result", update)
                                                            }
                                                        })

                                                    await appUsageSchema.findOne({ "customerId": id, "date": date })
                                                        .then((appData) => {
                                                            if (appData) {
                                                                callBack({
                                                                    success: true,
                                                                    STATUSCODE: 200,
                                                                    message: "APP USAGE TIME",
                                                                    response_data: appData
                                                                })
                                                            } else {
                                                                callBack({
                                                                    success: false,
                                                                    STATUSCODE: 400,
                                                                    message: "INTERNAL DB ERROR",
                                                                    response_data: {}
                                                                })
                                                            }
                                                        })
                                                }
                                            })
                                    }

                                }
                                else {
                                    if (IN && !OUT) {
                                        var today = moment()
                                        OUT = moment(today).format("HH:mm:ss")
                                        // console.log("OUT from first if =====", moment().format('DD-MM-YYYY'))

                                        var sum = appUsage(IN, OUT, '0')

                                        var newUsageData = new appUsageSchema({
                                            name: result.fullName,
                                            email: result.email,
                                            customerId: result._id,
                                            date: date,
                                            IN: IN,
                                            OUT: OUT,
                                            // appUsage: sum
                                        })

                                        await newUsageData.save((err, newAppUsageData) => {
                                            if (err) {
                                                callBack({
                                                    success: false,
                                                    STATUSCODE: 400,
                                                    message: 'Something Went Wrong',
                                                    response_data: {}
                                                })
                                            } else {
                                                newUsageData.appUsage = sum
                                                callBack({
                                                    success: true,
                                                    STATUSCODE: 200,
                                                    message: 'APP USAGE TIME',
                                                    response_data: newAppUsageData
                                                })
                                            }
                                        })

                                        //    callBack({
                                        //     IN: IN,
                                        //     OUT: OUT,
                                        //     response_data: sum
                                        //    })
                                    } else if (!IN && OUT) {
                                        await appUsageSchema.findOne({ "customerId": id, "date": date })
                                            .then(async (appData) => {
                                                console.log("appData =-=-=-=-=--=", appData)
                                                var sum = appUsage(appData.IN, OUT, '0')

                                                await appUsageSchema.updateOne({ "customerId": id, "date": date },
                                                    {
                                                        "appUsage": sum,
                                                        "OUT": OUT
                                                    }, (err, result) => {
                                                        if (err) {
                                                            console.log(err)
                                                        } else {
                                                            console.log(result)
                                                        }
                                                    })

                                                await appUsageSchema.findOne({ "customerId": id, "date": date })
                                                    .then((result) => {
                                                        if (result) {
                                                            callBack({
                                                                success: true,
                                                                STATUSCODE: 200,
                                                                message: "APP USAGE TIME",
                                                                response_data: result
                                                            })
                                                        } else {
                                                            callBack({
                                                                success: false,
                                                                STATUSCODE: 400,
                                                                message: "Internal DB error",
                                                                response_data: {}
                                                            })
                                                        }
                                                    })
                                            })
                                    }
                                }
                            })

                        // callBack({
                        //     response_data: {result}
                        // })
                    } else {
                        callBack({
                            success: false,
                            STATUSCODE: 400,
                            message: 'NO DATA FOUND',
                            response_data: {}
                        })
                    }
                })
        }
    }
}

function appUsage(IN, OUT, appUsageData) {

    console.log("inside function =-=-=-=-=", IN, OUT, appUsageData)
    // converting IN time and OUT time to moment object
    var inTime = moment(IN, 'HH:mm:ss')
    var outTime = moment(OUT, 'HH:mm:ss')

    console.log("in and out=-=-=-=-=", inTime, outTime)

    // calculating difference between out time and in time to get the total duration
    var time = (moment.duration(outTime.diff(inTime)));

    // console.log("time=-=-=-=-=", time)
    console.log("Getting time in hours =-=-=-=-=", time.asHours())

    // getting the duration in either minutes or hours
    console.log(appUsageData, typeof (appUsageData))
    if (appUsageData == undefined || appUsageData == null || appUsageData == '0') {
        var sum = 0
    } else {
        var sum = parseInt(appUsageData)
        if (sum < 0) {
            sum = 0
        }
    }

    console.log("iniial sum ==", sum)
    // var minutes = time._data.minutes
    // var hours = time.asHours()

    sum += time.asHours()
    sum = sum.toFixed(2)
    // if(hours == 0){
    //     sum += time._data.minutes
    //     sum = sum
    // } else {
    //     sum += time._data.hours
    //     sum = sum
    // }

    console.log("sum =-=-=-=-=", sum)

    return sum


}