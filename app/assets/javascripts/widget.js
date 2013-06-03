if(typeof(jQuery) == 'undefined'){
  document.write("<script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'></script>");
}

Widget = {};
Widget.gui = (function(){
	
	var popupCenter = function(url, width, height, name) {
	  var left = (screen.width/2)-(width/2);
	  var top = (screen.height/2)-(height/2);
	  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
	};
	
	return {
		activateToogleWeekDetail: function(className, hiddenClass){
			$('.'+className).click(function(){
				$(this).parents('tr:first').next('.'+hiddenClass).toggle();
			});
		},
		activatePopupCenter: function(className, url, width, height, name) {
		    $("a."+className).click(function(e) {
			    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
			    e.stopPropagation(); 
			    return false;
		    });
		},
		popupCenter: function(url, width, height, name) {
		   popupCenter(url, width, height, name);
		}
	};
})();

$(document).ready(function(){
	Widget.gui.activatePopupCenter('auth_popup');
	Widget.gui.activateToogleWeekDetail('toogle_day_view_link', 'week_day_detail');
});



