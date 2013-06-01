if(typeof(jQuery) == 'undefined'){
  document.write("<script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js'></script>");
}

function popupCenter(url, width, height, name) {
  var left = (screen.width/2)-(width/2);
  var top = (screen.height/2)-(height/2);
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
}

$(document).ready(function(){
	$("a.auth_popup").click(function(e) {
	  popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
	  e.stopPropagation(); return false;
	});
});
