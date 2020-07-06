// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require underscore
//= require jquery3
//= require gmaps/google
//= require_tree .

$(document).ready(function () {
    clockUpdate();
    setInterval(clockUpdate, 1000);
  });
  
  function clockUpdate() {
    var date = new Date(); // creates a date object
  
    function addZero(x) { // this is used when a value is < 10, adds the zero as in a digital clock
      if (x < 10) {
        return (x = "0" + x);
      } else {
        return x; // else returns the initial value
      }
    }
    // initializing clock variables
    var h = addZero(date.getHours());
    var m = addZero(date.getMinutes());
    var s = addZero(date.getSeconds());

    var d = new Date(); // new date object for the actual date

    var month = d.getMonth() + 1;
    var day = d.getDate();

    // this is what actualy builds and displays the clock + date
    $(".digital-clock").text(
    day + "/" + month + "/" + d.getFullYear() + " · " + h + ":" + m + ":" + s
    );
    $(".boxContenuto").load("show.html.erb");
    }

    var dt = new Date();
    document.getElementById("datetime").innerHTML = dt.toLocaleString();


    function loadlink(){
      $('#links').load('test.php',function () {
           $(this).unwrap();
      });
  }
  
  loadlink(); // This will run on page load
  setInterval(function(){
      loadlink() // this will run after every 5 seconds
  }, 5000);