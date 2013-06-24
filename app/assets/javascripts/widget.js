
Widget = {};
Widget.gui = (function(){
	
	var popupCenter = function(url, width, height, name) {
	  var left = (screen.width/2)-(width/2);
	  var top = (screen.height/2)-(height/2);
	
	  return window.open(url, name, "directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
	};
	
	return {
		activateToogleWeekDetail: function(className, hiddenClass){
			$('.'+className).click(function(){
				$(this).parents('tr:first').next('.'+hiddenClass).toggle();
			});
		},
		activateAuthPopupCenter: function(className, url, width, height) {
		    $("a."+className).click(function(e) {
				var ismock = $(this).attr('data-ismock');
				var isevent = $(this).attr('data-isevent');
				var eventid = $(this).attr('data-event');
			    popupCenter(url+"?isevent="+isevent+"&ismock="+ismock+"&event="+eventid, width, height, "authPopup");
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
	Widget.gui.activateAuthPopupCenter('auth_popup', 'http://localhost:3000/widget/login/popup', 550, 600);
	Widget.gui.activateToogleWeekDetail('toogle_day_view_link', 'week_day_detail');
});



