// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
    $.datepicker.setDefaults({
	dateFormat: 'mm/dd/yy',
	changeMonth: true,
	changeYear: true
    })
    $('p.date input').datepicker();

    $('a.delete-property').live('click', function() {
	$(this).closest('div.property').fadeOut(500, function() { $(this).remove(); });
	return false;
    });

    $('a.add-property').live('click', function() {
	var link = this;
	$.get('/admin/datasets/new_property?base_name='+link.rel, function(html) {
	    $(html).insertBefore(link);
	});
	return false;
    });

    $('a.seed-properties').click(function() {
	var link = this;
	$('<div/>').attr('id', 'seed-properties-dialog').appendTo(document.body);
	$('#seed-properties-dialog').load('/admin/datasets/seed_properties', function() {
	    $('#seed-properties-dialog').dialog({width: 400,
						 height: 200,
						 title: 'Seed Source Properties',
						 close: function() {
						     $(this).dialog('destroy');
						     $('#seed-properties-dialog').remove();
						 },
						 buttons: {
						     'Submit': function() { $('#seed-properties-form').submit(); },
						     'Cancel': function() { $(this).dialog('close'); }
						 }
						});

	    $('#seed-properties-form').iframePostForm({
		complete: function(response) {
		    $(response).insertAfter($(link).parent());		    
		    $('#seed-properties-dialog').dialog('close');
		}
	    });

	});					  
	return false;
    });
});

