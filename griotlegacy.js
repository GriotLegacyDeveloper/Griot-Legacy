var express = require('express');
var fileUpload = require('express-fileupload');
var path = require('path');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var logger = require('morgan');
var fs = require('fs');
var http = require('http');
var https = require('https');
const config = require('./config');
const mongoose = require('mongoose');
var cors = require('cors');
const corsMiddleWare = require('./middlewares/cors-middleware');

var app = express();
app.use(cors());

//======== Create Server Starts =======//

if (config.environment == 'staging') {
    var credentials = {
        key: fs.readFileSync('/etc/letsencrypt/live/nodeserver.brainiuminfotech.com/privkey.pem', 'utf8'),
        cert: fs.readFileSync('/etc/letsencrypt/live/nodeserver.brainiuminfotech.com/fullchain.pem', 'utf8')
    };

    var server = https.createServer(credentials, app);

} else if (config.environment == 'development') {
    var server = http.createServer(app);
}

//======== Create Server ends =======//

app.use(logger('dev'));

app.use(express.static('public'));



//====== Add Middleware for Rest Starts ======//
// app.use(express.json({ extended: true, limit: '200000kb', parameterLimit: 200000 * 100 }));
// app.use(express.urlencoded({ extended: true, limit: '200000kb', parameterLimit: 200000 * 100 }));

app.use(express.json({ extended: true, limit: '200000kb', parameterLimit: 200000 * 100 }));
app.use(express.urlencoded({ extended: true, limit: '200000kb', parameterLimit: 200000 * 100 }));
app.use(fileUpload({
    limits: { fileSize: 50 * 1024 * 1024 * 1024 },
}));
//====== Add Middleware for Rest Ends ======//

app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

//===== CORS Support Statrs =====//
app.use(corsMiddleWare);
//===== CORS Support Ends =====//

//==== Load Router =====//

const userRoutes = require('./routes/user');
app.use('/api/user', userRoutes);

const postRoutes = require('./routes/post');
app.use('/api/post', postRoutes);

const tribeRoutes = require('./routes/tribe');
app.use('/api/tribe', tribeRoutes);

const appUsageRouter = require('./routes/appUsage')
app.use('/api/track', appUsageRouter)

const paymentRouter = require('./routes/payment')
app.use('/api/payment', paymentRouter)

app.get('/paymentSuccess', (req, res) => {
    res.sendFile('payment-successful.html', { root: 'public' });
});

app.get('/paymentCancelled', (req, res) => {
    res.sendFile('payment-canceled.html', { root: 'public' })
})





//===== MongoDB Connection starts =====//



//
const productionDBString = `mongodb://${config.production.username}:${config.production.password}@${config.production.host}:${config.production.port}/${config.production.dbName}?authSource=${config.production.authDb}`;

var options = {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true
};


mongoose.connect(productionDBString, options, function (err) {
    if (err) {
        console.log('Mongo db connection failed');
    } else {
        console.log(productionDBString);
        console.log('Connected to mongo db');
    }
});

/** Mongo on connection emit */
mongoose.connection.on('connect', function () {
    console.log('Mongo Db connection success');
});

/** Mongo db error emit */
mongoose.connection.on('error', function (err) {
    console.log(`Mongo Db Error ${err}`);
});

/** Mongo db Retry Conneciton */
mongoose.connection.on('disconnected', function () {
    console.log('Mongo db disconnected....trying to reconnect. Please wait.....');
    mongoose.createConnection();
})
//===== MongoDB Connection ends =====//

app.set('port', config.port);
server.listen(app.get('port'), function (err) {
    if (err) {
        throw err;
    } else {
        console.log(`GriotLegacy server is running and listening to ${config.serverhost}:${app.get('port')} `);
    }
});
// catch 404 and forward to error handler
app.use(function (req, res, next) {
    // console.log('404 error',err);
    console.log('404 error req headers', req.headers);
    console.log('404 error req files', req.files);
    console.log('404 error req', req.body);
    // next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {

    console.log('500 error req', req.files);
    console.log('500 error req', req.body);

    console.log('err', err);
});

server.timeout = 500000;
