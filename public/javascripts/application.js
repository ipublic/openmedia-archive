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
	$("#metadata_last_updated").datepicker();
	$("#metadata_created_date").datepicker();
	$("#metadata_beginning_date").datepicker();
	$("#metadata_ending_date").datepicker();
});