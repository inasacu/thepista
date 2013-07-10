
Widget = {};
Widget.gui = (function(){
	
	var isLowerPartOfWindow = function(){
		return ($(window).scrollTop() == $(document).height() - $(window).height());
	};
	
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
				var sourceTimetableId = $(this).attr('data-source-timetable-id');
				var blockToken = $(this).attr('data-block-token');
				
				var iframeUrl = url+"?isevent="+isevent+"&ismock="+ismock+"&event="+eventid+
				"&source_timetable_id="+sourceTimetableId+"&block_token="+blockToken;
				
			    popupCenter(iframeUrl, width, height, "authPopup");
			    e.stopPropagation(); 
			    return false;
		    });
		},
		popupCenter: function(url, width, height, name) {
		   popupCenter(url, width, height, name);
		},
		detectScrollDownMessage: function(className){
			$(window).resize(function() {
			   console.log("resizing");
			 });
			
			$(window).scroll(function(){
				if(isLowerPartOfWindow()){
					$('.'+className).hide();
				}
				else{
					$('.'+className).show();
				}
			});
		}
	};
})();

$(document).ready(function(){
	Widget.gui.activateAuthPopupCenter('auth_popup', 'http://<@= ENV['THE_HOST'] %>/widget/login/popup', 550, 600);
	Widget.gui.activateToogleWeekDetail('toogle_day_view_link', 'week_day_detail');
});



