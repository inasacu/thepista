// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


// jquery cluetip script
$(document).ready(function() {
	$('span').cluetip({
		attribute: 'rel',
		local: true,
		hideLocal: true,
		arrows: true, 
		cursor: 'pointer',
		cluetipClass: 'jtip'
	});

	// $('a').cluetip({
	// 	attribute: 'rel',
	// 	local: true,
	// 	hideLocal: true,
	// 	arrows: true, 
	// 	cursor: 'pointer',
	// 	cluetipClass: 'jtip'
	// });
});

// jquery clear-input
// $(document).ready(function(){
//     $("input[type='text']").clearInput();
// });