// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
	$.datepicker.setDefaults({
		dateFormat: 'mm/dd/yy',
		changeMonth: true,
		changeYear: true
	})
});
$(function() {
    $('p.date input').datepicker();
});