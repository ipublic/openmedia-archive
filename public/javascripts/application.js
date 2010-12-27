// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {

	$('td button').button({
	  icons: {
	    primary: "ui-icon-triangle-1-s"
	  },
	  text: false
  })
	.click(function() {
		alert( "Display Edit Properties menu: Rename, Remove, New Property based on this Property..." )})
							

	$.datepicker.setDefaults({
		dateFormat: 'mm/dd/yy',
		changeMonth: true,
		changeYear: true
	})

	$('p.date input').datepicker();

	$( "#accordion" ).accordion({ autoHeight: false });
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