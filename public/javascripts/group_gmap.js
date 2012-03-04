<script type="text/javascript">

  function Menu($div){  }

$(function(){
	// var the_center = [51.488224, -0.131836];
	var the_center = [<%= NUMBER_LATITUDE %>, <%= NUMBER_LONGITUDE %>];

	var $map = $('#map'), 
	menu = new Menu($map),            
	current,  // current click event (used to save as start / end position)
	m1,       // marker "from"
	m2,       // marker "to"
	center = the_center;

	// INITIALIZE GOOGLE MAP
	$map.gmap3(

		{action: 'init',
			options:{
			center: the_center,
			zoom: 8,
			// mapTypeId: google.maps.MapTypeId.ROADMAP,
			mapTypeControl: true,
			navigationControl: true,
			scrollwheel: true,
			streetViewControl: true
			}
		}

	// add markers from database table
	,{ action: 'addMarkers',
	markers:[	

	<% marker = @group.marker %>
	<%= "{lat:#{marker.latitude}, lng:#{marker.longitude}, data:'#{marker.name}'}," %>

	],
	marker:{
		options:{
			draggable: false
		},
		events:{
			mouseover: function(marker, event, data){
				var map = $(this).gmap3('get'),
				infowindow = $(this).gmap3({action:'get', name:'infowindow'});
				if (infowindow){
					infowindow.open(map, marker);
					infowindow.setContent(data);
				} else {
					$(this).gmap3({action:'addinfowindow', anchor:marker, options:{content: data}});
				}
			},
			mouseout: function(){
				var infowindow = $(this).gmap3({action:'get', name:'infowindow'});
				if (infowindow){

					setTimeout(function() {
						// Do something after 3 seconds
						infowindow.close();
						}, 3000);

					}
				}
			}
		}
	}


	<% if DISPLAY_GEO_CODE %>
	// geo code user location
	,{ action : 'geoLatLng',
		callback : function(latLng){
			if (latLng){
				$(this).gmap3({
					action: 'addMarker', 
					latLng:latLng,
					map:{
						center: latLng
					}				
				},
				"autofit");
			} else {
				$('#search_result').html('<%= I18n.t(:you_are_not_here) %>');
			}
		}
	}

	<% end -%>
);
});
	
</script>