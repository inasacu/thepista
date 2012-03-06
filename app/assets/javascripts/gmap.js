var centerLatitude = 40.41562;
var centerLongitude = -3.682222;
var startZoom = 11;
var map;


function init() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.addControl(new GOverviewMapControl());
    map.addControl(new GScaleControl());
    
    map.setCenter(new GLatLng(centerLatitude, centerLongitude), startZoom);
    listMarkers();

    GEvent.addListener(map, "click", function(overlay, latlng) {
      if (map.getZoom() < 14){
                document.getElementById("save_form").spot_long.value = thePoint.y;
		document.getElementById("save_form").spot_lat.value = thePoint.x;
		map.panTo(thePoint);
		alert("You should zoom in close to be able to add a point.");
      }
      else if (overlay == null) {
        //create an HTML DOM form element
        var inputForm = document.createElement("form");
        inputForm.setAttribute("action","");
        inputForm.id='geocache-input'
        inputForm.onsubmit = function() {storeMarker(); return false;};
        
        //retrieve the longitude and lattitude of the click point
        var lng = latlng.lng();
        var lat = latlng.lat();
        
        inputForm.innerHTML = '<fieldset style="width:350px;">'
            //+ '<legend>New Location</legend>'
            + '<table border="0" cellpadding="0" cellspacing="0" width="100%">'
            + '<tbody>'
            + '<tr>'
            + '<td class="formName">Name</td>'
            + '<td class="formItem" width="100%">'
            + '<input type="text" id="name" name="m[name]" style="width:100%;"/></td></tr>'
            + '<tr>'
            + '<td class="formName">Sport</td>'
            + '<td class="formItem" width="100%">'
            + '<input type="text" id="activity" name="m[activity]" style="width:100%;"/></td></tr>'
            + '</tbody>'
            + '</table>'
            + '<input type="hidden" id="icon" name="m[icon]" style="width:100%" value="google_futbol_icon.png"/>'
            + '<input type="submit" value="Save"/>'
            + '<input type="hidden" id="longitude" name="m[longitude]" value="' + lng + '"/>'
            + '<input type="hidden" id="latitude" name="m[latitude]" value="' + lat + '"/>'
            + '</fieldset>';
  
        map.openInfoWindow (latlng,inputForm);
      }
    });
  }
}

function storeMarker(){
    var lng = document.getElementById("longitude").value;
    var lat = document.getElementById("latitude").value;

    var getVars =  "?m[name]=" + document.getElementById("name").value
        + "&m[activity]=" + document.getElementById("activity").value
        + "&m[icon]=" + document.getElementById("icon").value
        + "&m[longitude]=" + lng
        + "&m[latitude]=" + lat ;

    var request = GXmlHttp.create();

    //call the store_marker action back on the server
    request.open('GET', 'create' + getVars, true);
    request.onreadystatechange = function() {
        if (request.readyState == 4) {
            //the request is complete

            var success=false;
            var content='Error contacting web service';
            try {
              //parse the result to JSON (simply by eval-ing it)
              res=eval( "(" + request.responseText + ")" );
              content=res.content;
              success=res.success;              
            }catch (e){
              success=false;
            }

            //check to see if it was an error or success
            if(!success) {
                alert(content);
            } else {
                //create a new marker and add its info window
                var latlng = new GLatLng(parseFloat(lat),parseFloat(lng));                
                //var marker = createMarkerIcon(latlng, content, res.icon);                
                var marker = createMarker(latlng, content);
                map.addOverlay(marker);
                map.closeInfoWindow();
            }
        }
    }
    request.send(null);
    return false;
}


function createMarkerIcon(latlng, html, iconImage) {
  // alert(iconImage);
  if(iconImage!='') {
    var icon = new GIcon();
    icon.image = '../../assets/' + iconImage;
    icon.iconSize = new GSize(25, 25);
    icon.iconAnchor = new GPoint(14, 25);
    icon.infoWindowAnchor = new GPoint(14, 14);
    var marker = new GMarker(latlng,icon);
  } else {
    var marker = new GMarker(latlng);
  }

  GEvent.addListener(marker, 'click', function() {
    var markerHTML = html;
    marker.openInfoWindowHtml(markerHTML);    
  });
  return marker;
}

function createMarker(latlng, html) {
     var marker = new GMarker(latlng);
     GEvent.addListener(marker, 'click', function() {
          var markerHTML = html;
          marker.openInfoWindowHtml(markerHTML);
    });
    return marker;
}

function listMarkers() {
  var request = GXmlHttp.create();
  //tell the request where to retrieve data from.
  request.open('GET', 'list', true);
  //tell the request what to do when the state changes.
  request.onreadystatechange = function() {
    if (request.readyState == 4) {
	
      //parse the result to JSON,by eval-ing it.
      //The response is an array of markers
      markers=eval( "(" + request.responseText + ")" );
      for (var i = 0 ; i < markers.length ; i++) {
        //var marker=markers[i].attributes
        var marker=markers[i]
        var lat=marker.latitude;
        var lng=marker.longitude;
        //check for lat and lng so MSIE does not error
        //on parseFloat of a null value
        if (lat && lng) {
        var latlng = new GLatLng(parseFloat(lat),parseFloat(lng));
        
        //var html = '<div><b>name</b> ' + marker.name + '</div><div><b>activity</b> '+ marker.activity + '</div>';
        var html = "<table summary=\"Details\" width=\"350\" style=\"font-size: 10px\"><tr><td><strong>"
             + marker.name + "</strong><br>"
             + marker.activity + "<br>" 
             //+ "<a name=\"acc\" title=\"Is open to the public for free("
             //+ marker.public + ")\" style=\"border-bottom: dashed #578A24 1px;\" onClick=\"javascript:alert('Public Open\\nIs open to the public for free("
             //+ marker.public + ")');\">Public Open</a><br>" 
             + "addr:  " + marker.address + ", city:  " + marker.city + ", region:  " + marker.region + " " + marker.zip + "<br>" 
             + "<table><tr><td style=\"padding: 5px; font-size: 10px;\">" 
             + "<a href=\"http://maps.google.com/maps?f=d&hl=en&q=" + marker.address + ",+" + marker.city + ",+" + marker.region + "&ie=UTF8&om=1&z=15&ll="             
             + marker.latitude + "," + marker.longitude + "&iwloc=addr\" onClick=\"displayPopup('http://maps.google.com/maps?f=d&hl=en&q="
             + marker.address + ",+" + marker.city + ",+" + marker.region + "&ie=UTF8&om=1&z=15&ll="
             + marker.latitude + ","
             + marker.longitude + "&iwloc=addr','location',565,750,1,event,0);return false\" target=\"_blank\">Driving Directions</a></td></tr></table>"
             + marker.facility + "<br><br><table width=\"100%\"><tr><td style=\"padding: 0px; font-size: 10px;\">No Ratings</td><td nowrap style=\"padding: 0px; font-size: 10px; text-align: right\"><a href=\"../marker/review/id="
             + marker.id + "&name=" + marker.name + "\" onClick=\"displayPopup('../marker/review/id="
             + marker.id + "&name=" + marker.name + "','review',565,500,1,event,0);return false\" target=\"_blank\">Add rating</a></td></tr><tr><td style=\"padding: 0px; font-size: 10px;\">No Comments</td><td nowrap style=\"padding: 0px; font-size: 10px; text-align: right; vertical-align: top\"><a href=\"../marker/comment/id="
             + marker.id + "&name=" + marker.name + "\" onClick=\"displayPopup('../marker/create_comment/id="
             + marker.id + "&name=" + marker.name + "','comment',260,500,1,event,0);return false\" target=\"_blank\">Add update</a></td></tr></table></td></tr><tr><td><img src=\"../assets/invis.gif\" height=\"0\" width=\"350\"></td></tr>" 
             + "<tr><td style=\"font-size: 9px; padding-top: 10px;\">" 
             + "<a href=\"javascript:map.setMapType(G_NORMAL_MAP);map.setZoom(map.getZoom()-2);\">Street Level</a>&nbsp;|"
             + "&nbsp;<a href=\"javascript:map.setZoom(map.getZoom()+1);\">Zoom In</a>&nbsp;|"
             + "&nbsp;<a href=\"javascript:map.setZoom(map.getZoom()-1);\">Zoom Out</a>&nbsp;|"
             + "</br>&nbsp;<a href=\"javascript:map.getZoom()>=15?map.setZoom(map.getZoom()+1):map.setZoom(15);\">Zoom Way In</a>&nbsp;|"
             + "&nbsp;<a href=\"javascript:map.setMapType(G_NORMAL_MAP);map.setZoom(11);\">Zoom Way Out</a>&nbsp;|"
             + "&nbsp;<a href=\"../marker/show/" + marker.id + "\">Link</a></td></tr></table>";
                  
        //var marker = createMarkerIcon(latlng, html, marker.icon);        
        var marker = createMarker(latlng, html);
        map.addOverlay(marker);
        } // end of if lat and lng
      } // end of for loop
    } //if
  } //function
  request.send(null);
}

window.onload = init;
window.onunload = GUnload;
