const mongoose = require("mongoose");
const StoragePackage = require('./schema/package');
var config = require('./config')// Update the path to your model file
console.log("production ==>", config.production)
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

const seedData = [
    {
        size: "10",
        unit: "GB",
        price: "2.99", // Change this to the appropriate date for 2.99
        currency: "USD", // Assuming the currency is in US dollars
    },
    {
        size: "25",
        unit: "GB",
        price: "5.99", // Change this to the appropriate date for 5.99
        currency: "USD",
    },
    {
        size: "50",
        unit: "GB",
        price: "7.99", // Change this to the appropriate date for 7.99
        currency: "USD",
    },
    {
        size: "100",
        unit: "GB",
        price: "10.99", // Change this to the appropriate date for 10.99
        currency: "USD",
    },
    {
        size: "200",
        unit: "GB",
        price: "15.99", // Change this to the appropriate date for 15.99
        currency: "USD",
    },
    {
        size: "500",
        unit: "GB",
        price: 10.99, // Change this to the appropriate date for 20.99
        currency: "USD",
    },
];

async function seedDatabase() {
    try {
        // await StoragePackage.deleteMany({}); // Clear existing data in the collection
        await StoragePackage.insertMany(seedData); // Insert the seed data
        console.log("Seed data inserted successfully.");
    } catch (error) {
        console.error("Error seeding the database:", error);
    } finally {
        mongoose.disconnect(); // Close the database connection
    }
}

seedDatabase();
