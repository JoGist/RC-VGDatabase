require('dotenv').config()

var request = require ('request');

var options = {
    url: 'http://api.openweathermap.org/data/2.5/weather?q=Rome,IT&appid='+process.env.openWeatherAPI,
}

function callback(error, response, body) {
    if(!error && response.statusCode == 200) {
        var info = JSON.parse(body);
        console.log("##############################");
        console.log(info);
    }
}

request.get(options, callback);
