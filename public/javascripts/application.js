// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
    $.datepicker.setDefaults({
	dateFormat: 'mm/dd/yy',
	changeMonth: true,
	changeYear: true
    })
    $('p.date input').datepicker();

    $('a.delete-property').click(function() {
	$(this).closest('div.property').fadeOut(500, function() { $(this).remove(); });
	return false;
    });

    $('a#add-property').click(function() {
	var link = this;
	$.get('/admin/datasets/new_property', function(html) {
	    $(html).insertBefore(link);
	});
	return false;
    });
});

