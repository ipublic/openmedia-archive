// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {

	$('th button').button({
	  icons: {primary: "ui-icon-triangle-1-s"},
	  text: false
  })

	.click(function() {
		alert( "Display Edit Properties menu: 'Rename', 'Remove', 'New Property', 'New Property based on this Property...'" )})

	$.datepicker.setDefaults({
		dateFormat: 'mm/dd/yy',
		changeMonth: true,
		changeYear: true
	})

	$('p.date input').datepicker();

	$("#accordion" ).accordion({ autoHeight: false });
	$('.accordion .head').click(function() {
		$(this).next().toggle('slow');
		return false;
		}).next().hide();

	$(".radio").buttonset();

	$('#new-ds-btn').click(function() {
		$('#existing-ds-fields').hide();
		$('#existing-ds-fields').find('input, select, textarea').each(function(idx, elm) { elm.disabled=true; });
		$('#new-ds-fields').show();
		$('#new-ds-fields').find('input, select, textarea').each(function(idx, elm) { elm.disabled=false; });
		});

	$('#existing-ds-btn').click(function() {
		$('#existing-ds-fields').show();
		$('#existing-ds-fields').find('input, select, textarea').each(function(idx, elm) { elm.disabled=false; });
		$('#new-ds-fields').hide();
		$('#new-ds-fields').find('input, select, textarea').each(function(idx, elm) { elm.disabled=true; });
		});

	//$(".radio input").click(function(evt) {
	//	$.get($("#radio").attr("action"), $("#radio").serialize(), null, "script");
	//	evt.stopImmediatePropagation(); 
	//	return false;
	//});

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

	var typeAutoCompleteOpts = {delay: 300,
		mustMatch: true,
		source: "/schema/classes/autocomplete",
		select: function(event, ui) {
		    $(event.target).next('input').val(ui.item.id);
		}};

	$('a.add-class-property').live('click', function() {
		var link = this;
		$.get('/schema/classes/new_property', function(html) {
			$(link).prev('ol').append(html);
			$(link).prev('ol').find('.property-type-uri:last').autocomplete(typeAutoCompleteOpts);
			$(link).prev('ol').find('a.delete-class-property:last').button({icons: {primary: "ui-icon-circle-close"}, text: false});    
			});
		return false;
	});
    
    $('a.delete-class-property').button({icons: {primary: "ui-icon-circle-close"}, text: false});    

    $('a.add-element').button({icons: {primary: "ui-icon-circle-plus"}});

    $('a.delete-class-property').live('click', function() {
	var deletedPropertyURI = $(this).closest('li.class-property').find('.class-property-uri').val();
	if (deletedPropertyURI) {
	    $(this).closest('form').prepend($('<input type="hidden"/>').attr('name','deleted_property_uris[]').attr('value',deletedPropertyURI));
	}
	$(this).closest('li.class-property').remove();
	return false;
    });

    $('.property-type-uri').autocomplete(typeAutoCompleteOpts);
    $('.datasource-class').autocomplete(typeAutoCompleteOpts);
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