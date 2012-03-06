var centerLatitude = 40.41562;
var centerLongitude = -3.682222;

var centerLatitude = 40.485531081726045;
var centerLongitude = -3.7153342366218567;

var startZoom = 8;
var map;
var geocoder = null;

function init() {
    if (GBrowserIsCompatible()) {   
        map = new GMap2(document.getElementById("map"));
        map.addControl(new GLargeMapControl());         // large map control
        map.addControl(new GMapTypeControl());
        map.setMapType(G_NORMAL_MAP); 
        // map.setMapType(G_SATELLITE_MAP); 
        // map.setMapType(G_HYBRID_MAP); 

        var overview = new GOverviewMapControl()
        map.addControl(overview);  // large area visible       
        // map.addControl(new GScaleControl()); 
  
        //map.addControl(new DragZoomControl(boxStyleOpts, otherOpts, ''));
        map.setCenter(new GLatLng(centerLatitude, centerLongitude), startZoom);

        listMarkers();
    
        GEvent.addListener(map, "click", function(overlay, latlng) {
            if (map.getZoom() < 16){
                document.getElementById("save_form").spot_long.value = thePoint.y;
		document.getElementById("save_form").spot_lat.value = thePoint.x;
		map.panTo(thePoint);
		alert("You should zoom in close to be able to add a point.");
            }
            else if (overlay == null){
                //create an HTML DOM form element
                var inputForm = document.createElement("form");
                inputForm.setAttribute("action","");
                inputForm.id='geocache-input';
                inputForm.onsubmit = function() {storeMarker(); return false;};
        
                //retrieve the longitude and lattitude of the click point
                var lng = latlng.lng();
                var lat = latlng.lat();
        
                inputForm.innerHTML = '<fieldset style="width:255px; height:255px;">'
             	+  '<div class="block" id="block-forms">' 
				+  '<div class="content">' 
				+  '<h2 class="title">Centro Deportivo</h2>' 
				+  '<div class="inner">' 
				
				+  '<div class="group">' 
				+  '<label class="label">Nombre</label>' 
				+  '<input class="text_field" id="marker_name" name="marker[name]" size="30" type="text"><br/>'  
				+  '</div>' 
				
				+  '<div class="group">' 
				+  '<label class="label">Dirección</label>' 
				+  '<input class="text_field" id="marker_address" name="marker[address]" size="30" type="text"><br/>'  
				+  '</div>'
				
				+  '<div class="group">' 
				+  '<label class="label">Ciudad</label>' 
				+  '<input class="text_field" id="marker_city" name="marker[city]" size="30" type="text"><br/>'  
				+  '</div>'

				+  '<div class="group">' 
				+  '<label class="label">Codigo Postal</label>' 
				+  '<input class="text_field" id="marker_zip" name="marker[zip]" size="30" type="text"><br/><br/>'    
				+  '</div>'

                + '<input type="hidden" id="icon" name="marker[icon]" value="pin_icon.png"/>'  
                + '<input type="hidden" id="longitude" name="marker[longitude]" value="' + lng + '"/>'  
                + '<input type="hidden" id="latitude" name="marker[latitude]" value="' + lat + '"/>'  

				+  '<div class="group navform">' 
				+  '<input type="submit" class="button" value="Guardar &rarr;" />'
				+  '</div>'
				+  '</div>'
				+  '</div>'
				+  '</div>'
				+ '</fieldset>'
            
                //geocoder = new GClientGeocoder();
                map.openInfoWindow (latlng,inputForm);
            }
        });
    }
}

function storeMarker(){
    var lng = $("longitude").value;
    var lat = $("latitude").value;
    var formValues=Form.serialize('geocache-input');
    var myAjax = new Ajax.Request( '/markers/create', 
    { method: 'post', 
        parameters: formValues,
        onComplete: function(request){
            //parse the result to JSON (simply by eval-ing it)
            res=eval( "(" + request.responseText + ")" );
      
            //check to see if it was an error or success
            if(!res.success) {
                alert('kool error:  ' + res.content);
            } else {
                //create a new marker and add its info window
                var latlng = new GLatLng(parseFloat(lat),parseFloat(lng));
                var marker = createMarker(latlng, res.content, res.icon);
        
                map.addOverlay(marker);
                map.closeInfoWindow();
            } // end of the res.success check
        }
    }); // end of the new Ajax.Request() call
}

function createMarker(latlng, html, iconImage) {
    if(iconImage!='') {
        var icon = new GIcon();
        icon.image = iconImage;
        icon.iconSize = new GSize(25, 25);
        icon.iconAnchor = new GPoint(14, 25);
        icon.infoWindowAnchor = new GPoint(14, 14);
        var marker = new GMarker(latlng, icon);
    } else {
        var marker = new GMarker(latlng);
    }

    GEvent.addListener(marker, 'click', function() {
        var markerHTML = html;
        marker.openInfoWindowHtml(markerHTML);
    });
    return marker;
}

function listMarkers(){
    //alert('w/prototype');
    var myAjax = new Ajax.Request( '../../markers/list', 
    { method: 'GET', 
        onComplete: function(request){
            //parse the result to JSON (simply by eval-ing it). The response is an array of markers
            markers=eval( "(" + request.responseText + ")" );
    
            for (var i = 0 ; i < markers.length ; i++) {            
                var marker=markers[i]
                var lat=marker.latitude;
                var lng=marker.longitude;
          
                //check for lat and lng so MSIE does not error
                //on parseFloat of a null value
                if (lat && lng) {
                    var latlng = new GLatLng(parseFloat(lat),parseFloat(lng));

                    var html = "<table summary=\"Details\" width=\"350\" style=\"font-size: 10px\"><tr><td>"
                        + "<strong>Nombre:&nbsp;&nbsp;</strong>" + marker.name + "</strong><br>"
                        + "<strong>Direccion:&nbsp;&nbsp;</strong>" + marker.address + "<br>" 
                        + "<strong>Ciudad:&nbsp;&nbsp;</strong>" + marker.city + "<br>" 
                        + "<strong>C. Postal:&nbsp;&nbsp;</strong>" + marker.zip + "<br>" 
                        + "</td></tr>" 
                        + "<tr><td style=\"font-size: 9px; padding-top: 10px;\">"
                        + "<a href=\"javascript:map.setZoom(map.getZoom()+1);\">Zoom</a>&nbsp;|"
                        + "&nbsp;<a href=\"javascript:map.setZoom(map.getZoom()-1);\">Alejar el Zoom</a></td></tr>" 
                        + "<tr><td style=\"font-size: 9px; padding-top: 10px;\"><a href=\"javascript:map.getZoom()>=15?map.setZoom(map.getZoom()+1):map.setZoom(15);\">Zoom Way In</a>&nbsp;|"
                        + "&nbsp;<a href=\"javascript:map.setMapType(G_NORMAL_MAP);map.setZoom(11);\">Zoom Way Out</a>&nbsp;|"
                        + "&nbsp;<a href=\""
                        + marker.url + "\">Link on Local</a></td></tr>" 
                        + "<tr><td style=\"font-size: 9px; padding-top: 10px;\">"
                        + "&nbsp;<a href=\"../../groups/new/"
                        + marker.id + "\">Vincular a Equipo</a></td></tr></table>";

                    var marker = createMarker(latlng, html, '../../assets/' + marker.icon);
                    map.addOverlay(marker);
                } // end of if lat and lng
            } // end of for loop
        } // end of anonymous onComplete function
    }); // end of the new Ajax.Request() call
}

function getLocates(){
    var myAjax = new Ajax.Request( '/map/get_locate', 
    { method: 'GET', 
        onComplete: function(request){
            //parse the result to JSON (simply by eval-ing it). The response is an array of markers
            locates=eval( "(" + request.responseText + ")" );
//            alert(locates.length);            
        }
    });
}

/*
function showAddress(address) {
  if (geocoder) {
    geocoder.getLatLng(address,
      function(point) {
        if (!point) {
          alert(address + " not found");
        } else {
          if (addressMarker) {
            map.removeOverlay(addressMarker);
          }
          addressMarker = new GMarker(point);
          map.setCenter(point, 15);
          map.addOverlay(addressMarker);
        }
      }
    );
  }
}

function getWeatherMarkers(n) {
  var batch = [];
  for (var i = 0; i < n; ++i) {
    batch.push(new GMarker(getRandomPoint(), { icon: getWeatherIcon() }));
  }
  return batch;
}

function setupWeatherMarkers() {
  mgr = new MarkerManager(map);
  mgr.addMarkers(getWeatherMarkers(20), 3);
  mgr.addMarkers(getWeatherMarkers(200), 6);
  mgr.addMarkers(getWeatherMarkers(1000), 8);
  mgr.refresh();
}
 */

window.onload = init;
window.onunload = GUnload;
