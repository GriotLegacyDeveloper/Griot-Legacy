var userSchema = require('../../schema/User')
var moment = require('moment')

var appUsageSchema = require('../../schema/Appusage')

module.exports.appUsage = async(req,res)=>{
    var IN = req.body.IN
    var OUT = req.body.OUT
    var id = req.body.id
    var date = req.body.date

    var inTimeMoment 
    var outTimeMoment 

    var dateArray = []
    var uniqueDate = []

    await userSchema.findOne({"_id": id}, async (err,userData)=>{
        if(err){
            console.log("error fetching data from user schema")
        } else {
            await appUsageSchema.findOne({"customerId": id, "date": date}, async (err,result)=>{
                if(err){
                    console.log(err)
                } else {
                    console.log("this is result === ", result)
    
                    if(!result){
                        console.log("inside result if===", result)

                        if(IN && !OUT){
                            var today = new Date()

                            var hours = today.getHours()
                            var minutes = today.getMinutes()
                            var seconds = today.getSeconds()

                            OUT = hours+":"+minutes+":"+seconds
                            console.log("This is OUT from first if===",OUT)

                            // converting in time to moment
                            inTimeMoment = (moment(IN, 'HH:mm:ss'));
                            console.log('In time moment====', inTimeMoment)

                            // converting in time to moment
                            outTimeMoment = (moment(OUT, 'HH:mm:ss'));
                            console.log('In time moment====', inTimeMoment)

                            // calculating time
                            var time = (moment.duration(outTimeMoment.diff(inTimeMoment)));

                            // DIFFERENCE IN MINUTES
                            var minutes = (parseInt(time.asMinutes()))
                            console.log("\nThis is duration in minutes=====", minutes)

                            // difference in hours
                            var hours = (parseInt(time.asHours()))
                            console.log('\nThis is duration in hours === ', hours)



                            var sum = 0
                            // sum = parseInt(sum)

                            sum += hours

                            console.log("This is sum ===", sum, typeof(sum))

                            // await appUsageSchema.updateOne({"customerId": id, "date": date}, {"appUsage": sum, "IN": IN}, (err,result)=>{
                            //     if(err){
                            //         console.log("error updating appUsageSchema")
                            //     } else {
                            //         console.log("Updated Sum successfully", result.appUsage, result.IN)
                            //     }
                            // })
                            var newData = new appUsageSchema({ 
                                name: userData.fullName, 
                                customerId: userData._id,
                                email: userData.email,
                                countryCode: userData.countryCode,
                                phone: userData.phone,
                                date: date,
                                IN: IN,
                                OUT: OUT,
                                appUsage: sum
                            });
            
                            // save model to database
                            newData.save(function (err, appUsageData) {
                            if (err){
                                console.log(err);
                            } else {
                                console.log(" saved to appUsage collection.");
                                res.status(200).send({
                                    success: true,
                                    message: "APP USAGE TIME",
                                    response_data: appUsageData
                                })
                            }
                            }); 

                        } else if(!IN && OUT){

                            var appUsageData = await appUsageSchema.findOne({"customerId": id})
                            console.log("this is appUsageData == ", appUsageData)

                            // converting in time to moment
                            inTimeMoment = (moment(appUsageData.IN, 'HH:mm:ss'));
                            console.log('In time moment====', inTimeMoment)

                            // converting in time to moment
                            outTimeMoment = (moment(OUT, 'HH:mm:ss'));
                            console.log('In time moment====', outTimeMoment)

                            // calculating time
                            var time = (moment.duration(outTimeMoment.diff(inTimeMoment)));

                            // DIFFERENCE IN MINUTES
                            var minutes = (parseInt(time.asMinutes()))
                            console.log("\nThis is duration in minutes=====", minutes)

                            // difference in hours
                            var hours = (parseInt(time.asHours()))
                            console.log('\nThis is duration in hours === ', hours)

                            var sum = 0
                            // sum = parseInt(sum)

                            sum += hours

                            console.log("This is sum ===", sum, typeof(sum))

                            await appUsageSchema.updateOne(
                                {"customerId": id},
                                {"$set": 
                                    {
                                        "appUsage": sum,
                                        "OUT" : OUT
                                    }
                                }
                            )

                           await appUsageSchema.findOne({"customerId": id})
                            .then((result)=>{
                                res.status(200).send({
                                    success: true,
                                    message: "APP USAGE TIME",
                                    response_data: result
                                })
                            }) 
                        }

                    } else {
                            if(IN && !OUT){
                                var today = new Date()

                                var hours = today.getHours()
                                var minutes = today.getMinutes()
                                var seconds = today.getSeconds()

                                var appData = await appUsageSchema.findOne({"customerId": id})

                                OUT = hours+":"+minutes+":"+seconds
                                console.log("This is OUT from first if===",OUT)

                                // converting in time to moment
                                inTimeMoment = (moment(IN, 'HH:mm:ss'));
                                console.log('In time moment====', inTimeMoment)

                                // converting in time to moment
                                outTimeMoment = (moment(OUT, 'HH:mm:ss'));
                                console.log('In time moment====', inTimeMoment)

                                // calculating time
                                var time = (moment.duration(outTimeMoment.diff(inTimeMoment)));

                                // DIFFERENCE IN MINUTES
                                var minutes = (parseInt(time.asMinutes()))
                                console.log("\nThis is duration in minutes=====", minutes)

                                // difference in hours
                                var hours = (parseInt(time.asHours()))
                                console.log('\nThis is duration in hours === ', hours)

                                var sum = appData.appUsage
                                sum = parseInt(sum)

                                sum += hours

                                console.log("This is sum ===", sum, typeof(sum))

                                await appUsageSchema.updateOne({"customerId": id}, {"appUsage": sum, "IN": IN, "OUT": OUT}, (err,result)=>{
                                    if(err){
                                        console.log("error updating appUsageSchema")
                                    } else {
                                        console.log("Updated Sum successfully", result.appUsage, result.IN)
                                    }
                                })

                                await appUsageSchema.findOne({"customerId": id, "date": date})
                                .then((result)=>{
                                    res.status(200).send({
                                        success: true,
                                        message: "APP USAGE TIME",
                                        response_data: result
                                    })
                                }) 

                            } else if(!IN && OUT){

                                var appUsageData = await appUsageSchema.findOne({"customerId": id})
                                console.log("This is appUsageData if result === ", appUsageData)

                                // converting in time to moment
                                inTimeMoment = (moment(appUsageData.IN, 'HH:mm:ss'));
                                console.log('In time moment====', inTimeMoment)

                                // converting in time to moment
                                outTimeMoment = (moment(OUT, 'HH:mm:ss'));
                                console.log('In time moment====', inTimeMoment)

                                // calculating time
                                var time = (moment.duration(outTimeMoment.diff(inTimeMoment)));

                                // DIFFERENCE IN MINUTES
                                var minutes = (parseInt(time.asMinutes()))
                                console.log("\nThis is duration in minutes=====", minutes)

                                // difference in hours
                                var hours = (parseInt(time.asHours()))
                                console.log('\nThis is duration in hours === ', hours)

                                var sum = appUsageData.appUsage
                                sum = parseInt(sum)

                                sum += hours

                                console.log("This is sum ===", sum, typeof(sum))

                                await appUsageSchema.updateOne({"customerId": id}, {"appUsage": sum, "OUT": OUT}, (err,result)=>{
                                    if(err){
                                        console.log("error updating appUsageSchema")
                                    } else {
                                        console.log("Updated Sum successfully")
                                    }
                                })

                                appUsageSchema.findOne({"customerId": id, "date": date})
                                    .then((result)=>{
                                        res.status(200).send({
                                            success: true,
                                            message: "APP USAGE TIME",
                                            response_data: result
                                        })
                                    }) 
                            }
                        
                    }
                }
            })
        }
    })
        

}