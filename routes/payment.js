var express = require('express')
var router = express.Router()
var app = express()
var paymentModel = require('../models/user/payment-model')

var paymentApi = express.Router();
paymentApi.use(express.json());
paymentApi.use(express.urlencoded({ extended: false }));

app.use(express.static('public'));


// checking price
paymentApi.post('/checkPrice', (req, res) => {
    paymentModel.checkPrice(req.body, (result) => {
        res.status(200).send(result)
    })
})


// Create Card Token
paymentApi.post('/createCardToken', (req, res) => {
    paymentModel.createCardToken(req.body, (result) => {
        res.status(200).send(result)
    })
})

// card list
paymentApi.post('/cardList', (req, res) => {
    paymentModel.stripeCardList(req.body, (result) => {
        res.status(200).send(result)
    })
})

// customer Payment
paymentApi.post('/customerPayment', (req, res) => {
    paymentModel.customerPayment(req, result => {
        res.status(200).send(result)
    })
})

// card save
paymentApi.post('/cardSave', (req, res) => {
    paymentModel.StripeCardSave(req, result => {
        res.status(200).send(result)
    })
})

// card delete
paymentApi.post('/cardDelete', (req, res) => {
    paymentModel.cardDelete(req, result => {
        res.status(200).send(result)
    })
})

// default card set
paymentApi.post('/defaultCardSet', (req, res) => {
    paymentModel.setDefaultCard(req, result => {
        res.status(200).send(result)
    })
})

// paypal payment
paymentApi.post('/paypalPayment', (req, res) => {
    console.log("paypal")
    paymentModel.paypalPayment(req, result => {
        res.status(200).send(result)
    })
})

// paypal payment execute
paymentApi.post('/paypalPayment/execute', (req, res) => {
    paymentModel.paymentExecute(req, result => {
        res.status(200).send(result)
    })
})

// payment Success page
paymentApi.get('/paymentSuccess', (req, res) => {
    console.log("ENTERED PAYMENT SUCCESS")
    paymentModel.paymentExecute(req.query, result => {
        console.log("result == ", result)
        res.sendFile('payment-successful.html', { root: 'public' });
    })
})

// payment cancelled page
paymentApi.get('/paymentCancelled', (req, res) => {
    res.sendFile('payment-canceled.html', { root: 'public' });
})

// apple pay
paymentApi.post('/applePay', (req, res) => {
    console.log(1)
    paymentModel.applePay(req, result => {
        res.status(200).send(result)
    })
})

module.exports = paymentApi