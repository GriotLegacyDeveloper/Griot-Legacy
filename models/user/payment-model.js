const config = require("../../config");
var stripe = require("stripe")(config.stripe.secretKey);
var advertisementSchema = require("../../schema/Advertisement");
var customerCardSchema = require("../../schema/customerCard");
var customerSchema = require("../../schema/User");
var storagePackageSchema = require("../../schema/package");
const paypal = require("paypal-rest-sdk");
const url = require("url");
const querystring = require("querystring");
const axios = require("axios");
const {access} = require("fs");

// configure AWS S3
const AWS = require("aws-sdk");
const s3 = new AWS.S3();
// configure paypal
paypal.configure({
  mode: "sandbox", // 'sandbox' or 'live' depending on your environment
  client_id: config.paypal.clientId,
  client_secret: config.paypal.secret,
});

module.exports = {
  checkPrice: async (data, callBack) => {
    if (data) {
      var adObj = {};
      respObj = {};
      await advertisementSchema
        .findOne({_id: data.advertisementId})
        .then(async (result) => {
          if (result) {
            // calculating difference between dates
            const difference = Math.abs(result.validTill - result.validFrom);
            const days = Math.ceil(difference / (1000 * 60 * 60 * 24)) + 1;
            console.log("days === ", days);
            // adObj.advertisement = result
            adObj.advertisementId = result._id;
            adObj.userId = data.userId;
            adObj.numberOfDays = days;
            adObj.pricePerDay = "$5";
            // adObj.totalCost = 5 * days;
            adObj.totalCost = 1;

            var amount = adObj.totalCost;
            await advertisementSchema.updateOne(
              {_id: data.advertisementId},
              {
                $set: {
                  amount: amount,
                },
              }
            );

            callBack({
              success: true,
              STATUSCODE: 200,
              message: "Ad Costs",
              response_data: adObj,
            });
          } else {
            callBack({
              success: true,
              STATUSCODE: 202,
              message: "No Advertisement Found",
              response_data: {},
            });
          }
        })
        .catch((err) => {
          console.log("err", err);
          callBack({
            success: false,
            STATUSCODE: 400,
            message: "something went wrong",
            response_data: {},
          });
        });
    }
  },
  createCardToken: async (data, callBack) => {
    if (data) {
      try {
        const token = await stripe.tokens.create({
          card: {
            number: data.cardNumber,
            exp_month: data.expMonth,
            exp_year: data.expYear,
            cvc: data.cvc,
          },
        });

        callBack({
          success: true,
          STATUSCODE: 200,
          message: "Token generated successfully",
          response_data: [{token: token.id}],
        });
      } catch (err) {
        console.log("<<<err>>>", err);
        callBack({
          success: false,
          STATUSCODE: 422,
          message: err.raw.message,
        });
      }
    }
  },
  stripeCardList: async (data, callBack) => {
    if (data) {
      try {
        var customerId = data.customerId;
        customerCardSchema
          .findOne({customerId: customerId})
          .then((cardDetails) => {
            var allCardArr = [];
            if (cardDetails) {
              stripe.customers
                .listSources(cardDetails.StripeAccountId, {})
                .then((customers) => {
                  var allCardArr = [];
                  if (customers.data) {
                    var addDetails = customers.data;
                    var count = 0;
                    for (let addDetail of addDetails) {
                      var allCardObj = {};
                      if (
                        addDetail.name == "" ||
                        addDetail.name == null ||
                        addDetail.name == undefined
                      ) {
                        addDetail.name = "";
                      }

                      allCardObj["name"] = addDetail.name;
                      allCardObj["card_id"] = addDetail.id;
                      allCardObj["card_type"] = addDetail.brand;
                      allCardObj["country"] = addDetail.country;
                      allCardObj["StripeAccountId"] = addDetail.customer;
                      allCardObj["exp_month"] = addDetail.exp_month;
                      allCardObj["exp_year"] = addDetail.exp_year;
                      allCardObj["last4"] = addDetail.last4;
                      allCardObj["isDefault"] = count == 0 ? "yes" : "no";
                      count++;
                      allCardArr.push(allCardObj);
                    }
                  }
                  callBack({
                    success: true,
                    STATUSCODE: 200,
                    message: "All Saved Cards",
                    response_data: allCardArr,
                  });
                });
            } else {
              callBack({
                success: true,
                STATUSCODE: 202,
                message: "No Cards Found",
                response_data: [],
              });
            }
          })
          .catch((err) => {
            callBack({
              success: false,
              STATUSCODE: 500,
              message: "Internal DB error",
              response_data: [],
            });
          });
      } catch (err) {
        console.log("<<err>>", err);
        callBack({
          success: false,
          STATUSCODE: 422,
          message: err,
        });
      }
    }
  },
  //customer payment
  customerPayment: async (data, callBack) => {
    if (data) {
      try {
        var customerId = data.body.customerId;
        var card_id = data.body.card_id;
        var total_amount = data.body.total_amount * 100;
        customerSchema.findOne({_id: customerId}).then(async (userRes) => {
          if (userRes) {
            customerCardSchema
              .findOne({customerId: customerId})
              .then(async (cardDetail) => {
                if (!cardDetail) {
                  callBack({
                    success: false,
                    STATUSCODE: 200,
                    message: "Card not found",
                  });
                } else {
                  stripe.customers
                    .update(cardDetail.StripeAccountId, {
                      default_source: card_id,
                    })
                    .then((cardUpdate) => {
                      stripe.paymentIntents
                        .create({
                          amount: total_amount,
                          customer: cardDetail.StripeAccountId,
                          currency: config.stripe.CURRENCY,
                          source: card_id,
                          confirm: true,
                        })
                        .then(async (charge) => {
                          if (data.body.paymentType == "advertisement") {
                            var statusObj = {
                              status: "PENDING",
                              paymentIntentId: charge.id,
                              paymentType: "STRIPE",
                            };
                            var update = await advertisementSchema.updateOne(
                              {_id: data.body.advertisementId},
                              {
                                $set: statusObj,
                              }
                            );

                            console.log("update ", update);
                          } else if (data.body.paymentType == "storage") {
                            console.log("STORAGE");
                            var packageData =
                              await storagePackageSchema.findOne({
                                _id: data.body.storagePackageId,
                              });
                            console.log("PackageData : ", packageData);
                            const userFolder = `${data.body.customerId}/`;

                            const {Metadata} = await s3
                              .headObject({
                                Bucket: "griotlegacy",
                                Key: userFolder,
                              })
                              .promise();
                            console.log("MetaData : ", Metadata);
                            const currentStorageSizeLimit = parseInt(
                              Metadata["x-amz-meta-storage-size-limit"] || 0
                            );
                            const updatedStorageSizeLimit =
                              currentStorageSizeLimit +
                              Number(packageData.size) * 1024 * 1024 * 1024;

                            console.log(
                              "Size limits :",
                              currentStorageSizeLimit,
                              updatedStorageSizeLimit
                            );

                            var update = await s3
                              .copyObject({
                                Bucket: "griotlegacy",
                                CopySource: `griotlegacy/${userFolder}`,
                                Key: userFolder,
                                MetadataDirective: "REPLACE",
                                Metadata: {
                                  "x-amz-meta-storage-size-limit":
                                    updatedStorageSizeLimit.toString(),
                                },
                              })
                              .promise();
                          }

                          console.log("update : ", update);
                          callBack({
                            success: true,
                            STATUSCODE: 200,
                            message: "Paid successfully",
                            response_data: cardUpdate,
                            charge: charge,
                          });
                        });
                    });
                }
              })
              .catch((err) => {
                console.log("err", err);
                callBack({
                  success: false,
                  STATUSCODE: 500,
                  message: "Internal DB error",
                  response_data: {},
                });
              });
          }
        });
      } catch (err) {
        console.log("ERR======", err);
        callBack({
          success: false,
          STATUSCODE: 422,
          message: err.raw.message,
        });
      }
    }
  },
  //StripeCard save
  StripeCardSave: async (data, callBack) => {
    console.log(1);
    if (data) {
      try {
        console.log(2);
        var customerId = data.body.customerId;
        var CardToken = data.body.cardToken;
        customerSchema.findOne({_id: customerId}).then(async (userRes) => {
          console.log(33, userRes);
          if (userRes) {
            console.log(3);
            customerCardSchema
              .findOne({customerId: customerId})
              .then(async (cardDetail) => {
                if (!cardDetail) {
                  console.log(4);
                  var userName = userRes.firstName + " " + userRes.lastName;
                  stripe.customers
                    .create({
                      email: userRes.email,
                      name: userName,
                      phone: userRes.phone,
                      source: CardToken,
                    })
                    .then((customers) => {
                      console.log(5);
                      var obj = new customerCardSchema({
                        customerId: customerId,
                        StripeAccountId: customers.id,
                        email: userRes.email,
                        phone: userRes.phone,
                        cardId: customers.default_source,
                      });
                      obj.save().then((dataSave) => {
                        console.log(6);
                        callBack({
                          success: true,
                          STATUSCODE: 200,
                          message: "Card saved Successfully",
                          response_data: {
                            card_id: customers.default_source,
                          },
                        });
                      });
                    })
                    .catch((err) => {
                      callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: err,
                      });
                    });
                } else {
                  console.log(7);
                  stripe.customers
                    .createSource(cardDetail.StripeAccountId, {
                      source: CardToken,
                    })
                    .then((cardSav) => {
                      console.log(8);
                      if (data.body.isDefault == "yes") {
                        stripe.customers
                          .update(cardDetail.StripeAccountId, {
                            default_source: cardSav.id,
                          })
                          .then((cardUpdate) => {
                            console.log(8);
                            callBack({
                              success: true,
                              STATUSCODE: 200,
                              message: "Card saved successfully",
                              response_data: {
                                card_id: cardSav.id,
                              },
                            });
                          })
                          .catch((err) => {
                            console.log(9);
                            callBack({
                              success: false,
                              STATUSCODE: 500,
                              message: err,
                            });
                          });
                      } else {
                        console.log(10);
                        callBack({
                          success: true,
                          STATUSCODE: 200,
                          message: "Card saved successfully",
                          response_data: {},
                        });
                      }
                    })
                    .catch((err) => {
                      console.log(11);
                      callBack({
                        success: false,
                        STATUSCODE: 500,
                        message: err,
                      });
                    });
                }
              })
              .catch((err) => {
                console.log(12);
                callBack({
                  success: false,
                  STATUSCODE: 500,
                  message: "Internal DB error",
                  response_data: {},
                });
              });
          }
        });
      } catch (err) {
        console.log(13);
        callBack({
          success: false,
          STATUSCODE: 422,
          message: err.raw.message,
        });
      }
    }
  },
  // card delete
  cardDelete: async (data, callback) => {
    if (data) {
      try {
        var customerId = data.body.userId;
        var cardId = data.body.cardId;
        console.log("data == ", customerId, cardId);
        await customerCardSchema
          .findOne({customerId: customerId})
          .then(async (cardDetail) => {
            console.log("data", cardDetail);
            stripe.customers
              .deleteSource(cardDetail.StripeAccountId, cardId)
              .then((response) => {
                console.log("response", response);
                callback({
                  success: true,
                  STATUSCODE: 200,
                  message: "Card deleted successfully",
                  response_data: {},
                });
              })
              .catch((err) => {
                callback({
                  success: false,
                  STATUSCODE: 422,
                  message: err,
                });
              });
          })
          .catch((err) => {
            console.log("err", err);
            callback({
              success: false,
              STATUSCODE: 422,
              message: err,
            });
          });
      } catch (err) {
        console.log("=== err ===", err);
        callback({
          success: false,
          STATUSCODE: 400,
          message: "Internal DB error",
          response_data: {},
        });
      }
    } else {
      callback({
        success: false,
        STATUSCODE: 502,
        message: "Please provide required information",
        response_data: {},
      });
    }
  },

  setDefaultCard: async (data, callback) => {
    if (data) {
      try {
        var customerId = data.body.customerId;
        var cardId = data.body.cardId;
        console.log("<<<>>>", customerId, cardId);
        customerCardSchema
          .findOne({_id: cardId, customerId: customerId})
          .then(async (cardDetail) => {
            console.log("carddetail -- ", cardDetail);
            stripe.customers
              .update(cardDetail.StripeAccountId, {default_source: cardId})
              .then((cardUpdate) => {
                callback({
                  success: true,
                  STATUSCODE: 200,
                  message: "This card is set as a default",
                  response_data: {},
                });
              })
              .catch((err) => {
                callback({
                  success: false,
                  STATUSCODE: 422,
                  message: err,
                  response_data: {},
                });
              });
          })
          .catch((err) => {
            console.log("err", err);
            callback({
              success: false,
              STATUSCODE: 422,
              message: err,
              response_data: {},
            });
          });
      } catch (err) {
        console.log("err", err);
        callback({
          success: false,
          STATUSCODE: 422,
          message: err,
          response_data: {},
        });
      }
    }
  },

  paypalPayment: async (data, callBack) => {
    if (data) {
      try {
        console.log("data", data.body);
        // const paymentData = {
        //     amount: '10.00',
        //     currency: 'USD'
        // }

        const paymentData = {
          intent: "sale",
          payer: {
            payment_method: "paypal",
          },
          transactions: [
            {
              amount: {
                total: data.body.amount,
                currency: "USD",
              },
              description: "Advertisement Payment",
            },
          ],
          redirect_urls: {
            return_url:
              config.serverhost +
              `/api/payment/paymentSuccess?advertisementId=${data.body.advertisementId}&packageId=${data.body.storagePackageId}&paymentType=${data.body.paymentType}&customerId=${data.body.userId}`,
            cancel_url: config.serverhost + "/api/payment/paymentCancelled",
          },
        };

        paypal.payment.create(paymentData, async (error, payment) => {
          if (error) {
            console.log("<<<payment error>>>", error);
            callBack({
              success: false,
              STATUSCODE: 400,
              message: "Something went wrong while processing the payment",
              response_data: error,
            });
            return;
          } else {
            console.log("<<<payment success>>>", payment);
          }

          // redirect user to approval page
          const approvalUrl = payment.links.find(
            (link) => link.rel === "approval_url"
          ).href;

          callBack({
            success: true,
            STATUSCODE: 200,
            message: "Please approve to complete the payment",
            response_data: {
              link: approvalUrl,
            },
          });
        });
      } catch (err) {
        console.log("<<<catch err>>>", err);
        callBack({
          success: false,
          STATUSCODE: 400,
          message: "Something went wrong",
          response_data: {},
        });
      }
    } else {
      callBack({
        success: false,
        STATUSCODE: 500,
        message: "Please provide required information",
        response_data: {},
      });
    }
  },

  paymentExecute: async (data, callBack) => {
    // const redirectUrl = data.body.redirectUrl
    // const parsedUrl = url.parse(redirectUrl)
    // const query = querystring.parse(parsedUrl.query)
    console.log("Query :", data);
    const paymentId = data.paymentId;
    const payerId = data.PayerID;

    // console.log(redirectUrl, parsedUrl, query, paymentId, payerId)

    paypal.payment.execute(
      paymentId,
      {payer_id: payerId},
      async (error, payment) => {
        if (error) {
          console.log("<<<execution error>>>", error);
          callBack({
            success: false,
            STATUSCODE: 400,
            message: "Something went wrong while executing payment",
            response_data: error,
          });
        } else {
          console.log(111111);
          console.log("<<success>>", payment);

          // base 64 encoded authString
          // const authString = Buffer.from(`${config.paypal.clientId}:${config.paypal.secret}`).toString('base64')

          // constants for paypal API endpoints
          // const paypalApiBaseUrl = 'https://api.sandbox.paypal.com';
          // const oauthEndpoint = '/v1/oauth2/token';
          // const paymentEndpoint = '/v2/payments/captures';

          // var accessToken = await getAccessToken(paypalApiBaseUrl, oauthEndpoint, authString)
          // var captureId = await getPaymentDetails(payerId, paymentId, accessToken, paypalApiBaseUrl, paymentEndpoint)
          if (data.paymentType == "advertisement") {
            var statusObj = {
              status: "PENDING",
              paymentType: "PAYPAL",
              paymentIntentId: payment.id,
            };
            var update = await advertisementSchema.updateOne(
              {_id: data.advertisementId},
              {
                $set: statusObj,
              }
            );
          } else if (data.paymentType == "storage") {
            console.log("STORAGE");
            var packageData = await storagePackageSchema.findOne({
              _id: data.packageId,
            });
            console.log("package :", packageData);

            const userFolder = `${data.customerId}/`;
            console.log("Id : ", data.customerId);

            const {Metadata} = await s3
              .headObject({
                Bucket: "griotlegacy",
                Key: userFolder,
              })
              .promise();

            console.log("MetaData : ", Metadata);

            const currentStorageSizeLimit = parseInt(
              Metadata["x-amz-meta-storage-size-limit"] || 0
            );
            const updatedStorageSizeLimit =
              currentStorageSizeLimit +
              Number(packageData.size) * 1024 * 1024 * 1024;

            console.log(
              "Size limits :",
              currentStorageSizeLimit,
              updatedStorageSizeLimit
            );

            var update = await s3
              .copyObject({
                Bucket: "griotlegacy",
                CopySource: `griotlegacy/${userFolder}`,
                Key: userFolder,
                MetadataDirective: "REPLACE",
                Metadata: {
                  "x-amz-meta-storage-size-limit":
                    updatedStorageSizeLimit.toString(),
                },
              })
              .promise();
          }

          // console.log("captureId === ", captureId)
          callBack({
            success: true,
            STATUSCODE: 200,
            message: "Payment made successfully",
            response_data: payment,
          });
        }
      }
    );
  },

  applePay: async (data, callback) => {
    if (data) {
      console.log(2, data.body);
      try {
        const {amount, token, currency, paymentType} = data.body;

        try {
          if (paymentType == "advertisement") {
            var statusObj = {
              status: "PENDING",
              paymentIntentId: token,
              paymentType: "STRIPE",
            };
            var update = await advertisementSchema.updateOne(
              {_id: data.body.advertisementId},
              {
                $set: statusObj,
              }
            );

            console.log("update ", update);
          } else if (paymentType == "storage") {
            console.log("STORAGE");
            var packageData = await storagePackageSchema.findOne({
              _id: data.body.storagePackageId,
            });
            console.log("PackageData : ", packageData);
            const userFolder = `${data.body.customerId}/`;

            const {Metadata} = await s3
              .headObject({
                Bucket: "griotlegacy",
                Key: userFolder,
              })
              .promise();
            console.log("MetaData : ", Metadata);
            const currentStorageSizeLimit = parseInt(
              Metadata["x-amz-meta-storage-size-limit"] || 0
            );
            const updatedStorageSizeLimit =
              currentStorageSizeLimit +
              Number(packageData.size) * 1024 * 1024 * 1024;

            var update = await s3
              .copyObject({
                Bucket: "griotlegacy",
                CopySource: `griotlegacy/${userFolder}`,
                Key: userFolder,
                MetadataDirective: "REPLACE",
                Metadata: {
                  "x-amz-meta-storage-size-limit":
                    updatedStorageSizeLimit.toString(),
                },
              })
              .promise();
          }

          return callback({
            success: true,
            STATUSCODE: 200,
            message: "Paid Successfully",
            response_data: {},
          });
        } catch (err) {
          console.log("err :: ", err);
          callback({
            response_code: 404,
            response_message: "Something went wrong",
            response_data: {},
          });
        }

        callback({
          success: true,
          STATUSCODE: 200,
          message: "Payment Successful",
          response_code: {},
        });
      } catch (err) {
        console.log("<<<catch err>>>", err);
        callback({
          success: false,
          STATUSCODE: 400,
          message: "Internal DB error",
          response_data: {},
        });
      }
    } else {
      callback({
        success: false,
        STATUSCODE: 400,
        message: "Provide all information",
        response_data: {},
      });
    }
  },
};

async function getAccessToken(paypalApiBaseUrl, oauthEndpoint, authString) {
  try {
    const response = await axios.post(
      `${paypalApiBaseUrl}${oauthEndpoint}`,
      "grant_type=client_credentials",
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          Authorization: `Basic ${authString}`,
        },
      }
    );

    return response.data.access_token;
  } catch (err) {
    console.log("<<<auth catch err>>>", err);
    return;
  }
}

async function getPaymentDetails(
  payerId,
  paymentId,
  accessToken,
  paypalApiBaseUrl,
  paymentEndpoint
) {
  try {
    const response = await axios.get(
      `${paypalApiBaseUrl}${paymentEndpoint}`,
      {
        amount: {
          currency_code: "USD",
          value: "35.00",
        },
        final_capture: true,
        payment_id: paymentId,
        payer_id: payerId,
      },
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
      }
    );

    return response.data.id;
  } catch (err) {
    console.log("<<<capture err>>>", err);
    return;
  }
}
