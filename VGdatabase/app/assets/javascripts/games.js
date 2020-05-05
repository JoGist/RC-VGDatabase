function initMap(lat) {
    var l = lat.split(','); 
    var myCoords = new google.maps.LatLng(l[0], l[1]);
    var mapOptions = {
    center: myCoords,
    zoom: 14
    };
    var map = new google.maps.Map(document.getElementById('map'), mapOptions);
}