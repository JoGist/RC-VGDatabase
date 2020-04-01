//before running the code, be sure to execute the following tasks:
//1. commands on terminal (in the project root folder):
//   npm init --yes
//   npm install request --save
//   npm install dotenv --save
//2. create a .env file with openWeatherAPI={yourAPIkey}

require('dotenv').config()

var request = require ('request');

var options = {
    url: 'http://api.openweathermap.org/data/2.5/weather?q=Rome,IT&units=metric&appid='+process.env.openWeatherAPI,
}

function callback(error, response, body) {
    console.log('Code '+response.statusCode);
    if(!error && response.statusCode == 200) {
        var info = JSON.parse(body);
        console.log('##############################');
        console.log(info);
        console.log('##############################');
    }
}

request.get(options, callback);
