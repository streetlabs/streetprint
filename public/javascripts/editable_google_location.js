window.addEvent('domready', function(){
  initialize_map();
});

function initialize_map() {
  if (GBrowserIsCompatible()) {
    // create map
    var map = new GMap2(document.getElementById("map_canvas"));
    
    // set initial position
    var location = null;
    if($('google_location') != null) {
      lat = $('latitude').get('value');
      lng = $('longitude').get('value');
      location = new GLatLng(lat, lng);
    }
    var center;
    var zoom;
    if(location != null) {
      center = location;
      zoom = 13
    } 
    else {
      center = new GLatLng(0,0);
      zoom = 2
    }
    map.setCenter(center, zoom);
    
    // default ui
    map.setUIToDefault();
    map.disableScrollWheelZoom();
    // add marker
    var marker = new GMarker(center, {draggable: true});
    map.addOverlay(marker);
    // add search bar
    map.enableGoogleBar();
    
    // right click event to move the marker
    GEvent.addListener(map, "singlerightclick", function(point, element, overlay) {
      location = map.fromContainerPixelToLatLng(point);
      marker.setLatLng(location);
    });
    
    // set the location before submitting the form
    var form = $$('div#set_google_location form');
    form.addEvent('submit', function(){
      location = marker.getLatLng();
      $('location').set('value', location.lat() + ", " + location.lng());
    });
  }
}