// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require jquery-ui



// jquery cluetip script
// $(document).ready(function() {
// 	$('span').cluetip({
// 		attribute: 'rel',
// 		local: true,
// 		hideLocal: true,
// 		arrows: true, 
// 		cursor: 'pointer',
// 		cluetipClass: 'jtip'
// 	});
// });

// $(function() {
// 	var availableTags = [];
// 	<% 
// 		counter = -1
// 		@items.each do |item| 
// 	%>
// 		availableTags[<%= counter+=1 %>] = "<%= item.name %>";
// 	<% end -%>
// 	
// 	function split( val ) {
// 		return val.split( /,\s*/ );
// 	}
// 	function extractLast( term ) {
// 		return split( term ).pop();
// 	}
// 
// 	$( "#autofill" )
// 		// don't navigate away from the field on tab when selecting an item
// 		.bind( "keydown", function( event ) {
// 			if ( event.keyCode === $.ui.keyCode.TAB &&
// 					$( this ).data( "autocomplete" ).menu.active ) {
// 				event.preventDefault();
// 			}
// 		})
// 		.autocomplete({
// 			minLength: 0,
// 			source: function( request, response ) {
// 				// delegate back to autocomplete, but extract the last term
// 				response( $.ui.autocomplete.filter(
// 					availableTags, extractLast( request.term ) ) );
// 			},
// 			focus: function() {
// 				// prevent value inserted on focus
// 				return false;
// 			},
// 			select: function( event, ui ) {
// 				var terms = split( this.value );
// 				// remove the current input
// 				terms.pop();
// 				// add the selected item
// 				terms.push( ui.item.value );
// 				// add placeholder to get the comma-and-space at the end
// 				terms.push( "" );
// 				this.value = terms.join( ", " );
// 				return false;
// 			}
// 		});
// });



$(document).ready(function () {
    // other routines here .. removed for clarity
    $("div[id$=_commentSystem]").css({ padding: ".5em" }).appear(function () {
        $.getScript("http://" + disqus_shortname + ".disqus.com/embed.js");
    });
});




