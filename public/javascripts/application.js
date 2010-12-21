// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {

	$.datepicker.setDefaults({
		dateFormat: 'mm/dd/yy',
		changeMonth: true,
		changeYear: true
	})

	$('p.date input').datepicker();

        $('#upload-dataset-tabs').tabs({
	    select: function(event, ui) {
		$('#upload-dataset-tabs').find('input, select, textarea').each(function(idx, elm) { elm.disabled=true; });
		$('#' + ui.panel.id).find('input, select, textarea').each(function(idx, elm) { elm.disabled=false; });
	    }
        });
    
        $('#file-type-tabs').tabs();

	$( "#accordion" ).accordion({ autoHeight: false });
	$('.accordion .head').click(function() {
		$(this).next().toggle('slow');
		return false;
		}).next().hide();

	$(".radio").buttonset();
	$(".radio input").click(function(evt) {
		$.get($("#radio").attr("action"), $("#radio").serialize(), null, "script");
		evt.stopImmediatePropagation(); 
		return false;
	});

    $('a.delete-property').live('click', function() {
	$(this).closest('div.property').fadeOut(500, function() { $(this).remove(); syncSourceProperties(); });
	return false;
    });

    $('a.add-property').live('click', function() {
	var link = this;
	$.get('/admin/datasets/new_property?base_name='+link.rel, function(html) {
	    $(html).insertBefore(link);
	});
	return false;
    });

    $('#source input.property-name').live('blur', syncSourceProperties);

});

function syncSourceProperties() {
    var sourceNames = $('#source input.property-name').map(function(idx, inputElm) { 
	return $(inputElm).val(); 
    });

    $('#property-set select.source-select').each(function(idx, selectElm) {
	var currentVal = $(selectElm).val();
	$(selectElm).html('<option/>');
	sourceNames.each(function(idx, sourceName) {
	    $('<option/>').attr('value', sourceName).
		attr('selected', (sourceName==currentVal)).
		html(sourceName).
		appendTo(selectElm);
	});
    });
}