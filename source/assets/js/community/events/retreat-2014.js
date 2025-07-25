function initialize() {
  var retreatLocation = new google.maps.LatLng(37.386739, -122.067961);
  var mapOptions = {
    zoom: 10,
    center: retreatLocation,
    scrollwheel: false
  };

  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  var marker = new google.maps.Marker({
    position: retreatLocation,
    map: map,
    title: 'Retreat Location'
  });

  google.maps.event.addDomListener(window, 'resize', function() {
    var center = map.getCenter();
    google.maps.event.trigger(map, 'resize');
    map.setCenter(center);
  });
}

function loadScript() {
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&' +
      'callback=initialize';
  document.body.appendChild(script);
}

window.onload = loadScript;