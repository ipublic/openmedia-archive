// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {

	$("ul.tabs li")
		.mouseover(function() {
			$("ul.tabs li").removeClass("active");			
			}
		)
		.click(function() {
		$("ul.tabs li").removeClass("active");
		$(this).addClass("active"); 
	});
		
// Example jQuery Sparklines 
	/* Inline sparklines take their values from the contents of the tag */
	$('.compositeline').sparkline('html', { fillColor: false }); 
  $('.compositeline').sparkline('html', { composite: true, fillColor: false, lineColor: 'blue' });

  // Bullet charts
  $('.bullet').sparkline('html', { type: 'bullet' });

  // Pie charts
  $('.pie').sparkline('html', { type: 'pie', height: '1.5em', offset: -90, 
																sliceColors: ['fb8072', 'b3de69', '80B1D3', 'FDB462', 
																							'FCCDE5', 'D9D9D9', 'BC80BD', 'CCEBC5', 
																              'FFED6F', '8DD3C7', 'FFFFB3', 'BEBADA']});


  // Tri-state charts using inline values
  $('.tristate').sparkline('html', {type: 'tristate'});
  $('.tristatecols').sparkline('html', {type: 'tristate', colorMap: {'-2': '#fa7', '2': '#44f'} });

  /* Inline sparklines take their values from the contents of the tag */
  $('.inlinesparkline').sparkline(); 

  /* Sparklines can also take their values from the first argument 
  passed to the sparkline() function */
  var myvalues = [10,8,5,7,4,4,1];
  $('.dynamicsparkline').sparkline(myvalues);

  /* The second argument gives options such as chart type */
  $('.dynamicbar').sparkline(myvalues, {type: 'bar', barColor: 'green'} );

  /* Use 'html' instead of an array of values to pass options 
  to a sparkline with data in the tag */
  $('.inlinebar').sparkline('html', {type: 'bar', barColor: 'red'} );

// END Example jQuery Sparklines 


	$("#tabs").tabs();
	
	$("#filter-collections").buttonset()
		.click(function(){
			
		});

	$( "#create-class" ).button()
		.click(function() {
			$( "#dialog-new-class-form" ).dialog( "open" );
	});
	
	$( "#dialog-new-class-form" ).dialog({
		autoOpen: false,
		height: 300,
		width: 350,
		modal: true,
		buttons: {
			"Save": function() {
				var bValid = true;
				allFields.removeClass( "ui-state-error" );

				// bValid = bValid && checkLength( name, "username", 3, 16 );
				// bValid = bValid && checkLength( email, "email", 6, 80 );
				// bValid = bValid && checkLength( password, "password", 5, 16 );

				if ( bValid ) {
					$( this ).dialog( "close" );
				}
			},
			Back: function() {
				$( this ).dialog( "close" );
			}
		},
		close: function() {
			allFields.val( "" ).removeClass( "ui-state-error" );
		}
	});

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

	$("#upload-accordion").accordion({ header: 'h2' });

  	$("#upload-accordion").accordion({ autoHeight: true,
  	  change: function(event, ui) { 
  		if($(this).accordion('option', 'active')==0) {
  		    $('#datasource_source_type').val('textfile');
  		}
  		else if($(this).accordion('option', 'active')==1) {
  		    $('#datasource_source_type').val('shapefile');
  		}
  		else if($(this).accordion('option', 'active')==2) {
  		    $('#datasource_source_type').val('webservice');
  		}
  		else if($(this).accordion('option', 'active')==3) {
  		    $('#datasource_source_type').val('database');
  		}
  	  }
  	});

	$('.accordion .head').click(function() {
		$(this).next().toggle('slow');
		return false;
		}).next().hide();

	$(".radio").buttonset();

	$('#ds_btn_new').click(function() {
		$('#existing-ds-fields').hide();
		$('#existing-ds-fields').find('input, select, textarea').each(function(idx, elm) { elm.disabled=true; });
		$('#new-ds-fields').show();
		$('#new-ds-fields').find('input, select, textarea').each(function(idx, elm) { elm.disabled=false; });
		});

	$('#ds_btn_existing').click(function() {
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
				source: "/admin/schema/classes/autocomplete",
				select: function(event, ui) {
				    $(event.target).next('input').val(ui.item.id);
				}};

	$('a.add-contact-email').live('click',
		function() {
		    var link = this;
		    $.get('/admin/contacts/new_email',
		    function(html) {
		        $(html).insertBefore(link);
		        $('a.add-element').button({icons: {primary: "ui-icon-circle-plus"}});
		        $('a.delete-element').button({icons: {primary: "ui-icon-circle-close"}, text: false
		        });
		    });
		    return false;
		});

	$('a.delete-contact-email').live('click',
		function() {
		    $(this).closest('ol').remove();
		    return false;
		});
		
	$('a.add-contact-telephone').live('click',
		function() {
		    var link = this;
		    $.get('/admin/contacts/new_telephone',
		    function(html) {
		        $(html).insertBefore(link);
		        $('a.add-element').button({icons: {primary: "ui-icon-circle-plus"}});
		        $('a.delete-element').button({icons: {primary: "ui-icon-circle-close"}, text: false
		        });
		    });
		    return false;
		});

	$('a.delete-contact-telephone').live('click',
		function() {
		    $(this).closest('ol').remove();
		    return false;
		});

	$('a.add-contact-address').live('click',
		function() {
		    var link = this;
		    $.get('/admin/contacts/new_address',
		    function(html) {
		        $(html).insertBefore(link);
		        $('a.add-element').button({icons: {primary: "ui-icon-circle-plus"}});
		        $('a.delete-element').button({icons: {primary: "ui-icon-circle-close"}, text: false
		        });
		    });
		    return false;
		});

	$('a.delete-contact-address').live('click',
		function() {
		    $(this).closest('ol').remove();
		    return false;
		});


	$('a.add-class-property').live('click',
	function() {
	    var link = this;
	    $.get('/admin/schema/classes/new_property',
	    function(html) {
	        $(html).insertBefore(link);
	        $(link).prev('ol').find('.property-type-uri:last').autocomplete(typeAutoCompleteOpts);
	        $(link).prev('ol').find('a.delete-element:last').button({
	            icons: {
	                primary: "ui-icon-circle-close"
	            },
	            text: false
	        });
	    });
	    return false;
	});
    
    $('a.delete-class-property').live('click', function() {
	var deletedPropertyURI = $(this).closest('ol.class-property').find('.class-property-uri').val();
	if (deletedPropertyURI) {
	    $(this).closest('form').prepend($('<input type="hidden"/>').attr('name','deleted_property_uris[]').attr('value',deletedPropertyURI));
	}
	$(this).closest('ol.class-property').remove();
	return false;
    });

    $('a.add-datasource-property').live('click', function() {
	var link = this;
	$.get('/admin/datasources/new_property', function(html) {
	    console.debug($(link).prev('ol'));
	    $(link).prev('ol').append(html);
	    $(link).prev('ol').find('.property-range-uri:last').autocomplete(typeAutoCompleteOpts);
	    $(link).prev('ol').find('a.delete-element:last').button({icons: {primary: "ui-icon-circle-close"}, text: false});    
	});
	return false;
    });

    $('a.delete-datasource-property').live('click', function() {
	$(this).closest('li.datasource-property').remove();
	return false;
    });

    $('#datasource_metadata_description, #datasource_creator_uri, #datasource_publisher_uri').change(function() {
	var desc = $('#datasource_metadata_description').val();
	var creator_uri = $('#datasource_creator_uri').val();
	var publisher_uri = $('#datasource_publisher_uri').val();
	if (desc !='' && creator_uri != '' && publisher_uri != '') {
	    $('#publish-button').removeAttr("disabled");
	} else {
	    $('#publish-button').attr("disabled", "disabled");
	}

    });

    // Dashboard Admin
	$('a.add-measure-group').live('click',
	function() {
	    var link = this;
	    $.get('/admin/dashboards/new_group',
	    function(html) {
	        $(html).insertBefore(link);
	        $('a.add-element').button({
	            icons: {
	                primary: "ui-icon-circle-plus"
	            }
	        });
	        $('a.delete-element').button({
	            icons: {
	                primary: "ui-icon-circle-close"
	            },
	            text: false
	        });
	    });
	    return false;
	});

    $('a.delete-dashboard-group').live('click', function() {
	$(this).closest('ol').next('ol').remove();
	$(this).closest('ol').remove();
	return false;
    });

    $('a.delete-measure').live('click', function() {
	$(this).closest('table').remove();
	return false;
    });

    var dashboardClassAutoCompleteOpts = {delay: 300,
					  mustMatch: true,
					  source: "/admin/schema/classes/autocomplete",
					  select: function(event, ui) {
					      var classURI = ui.item.id;
					      $(event.target).next('input').val(classURI);
					      $.getJSON('/admin/schema/classes/property_list?class_uri='+classURI, function(data) {
						  $(event.target).closest('table').find('input.dashboard-property').autocomplete({source: data});
					      });

					  }};

    // setup property autocomplete for all measures with class set
    $('.dashboard-source-class').each(function() {
	var classURI = $(this).next().val();
	var sourceClassInput = this;
	if (classURI != '' && classURI != null) {
	    $.getJSON('/admin/schema/classes/property_list?class_uri='+classURI, function(data) {
		$(sourceClassInput).closest('table').find('input.dashboard-property').autocomplete({source: data});
	    });
	}
    });

    $('a.add-measure').live('click', function() {
	var link = this;
	$.get('/admin/dashboards/new_measure', function(html) {
	    $(html).insertBefore(link);
	    $(link).prev().find('.dashboard-source-class').autocomplete(dashboardClassAutoCompleteOpts);
	    $('a.add-element').button({icons: {primary: "ui-icon-circle-plus"}});
	    $('a.delete-element').button({icons: {primary: "ui-icon-circle-close"}, text: false});    
	});
	return false;
    });
    $('.dashboard-source-class').autocomplete(dashboardClassAutoCompleteOpts);


    // basic button styling
    $('a.add-element').button({icons: {primary: "ui-icon-circle-plus"}});
    $('a.delete-element').button({icons: {primary: "ui-icon-circle-close"}, text: false});    
    $('.datasource-class').autocomplete(typeAutoCompleteOpts);
    $('.property-type-uri').autocomplete(typeAutoCompleteOpts);
    $('.property-range-uri').autocomplete(typeAutoCompleteOpts);
    $('.datasource-class-uri').autocomplete(typeAutoCompleteOpts);

    $('#source input.property-name').live('blur', syncSourceProperties);
    $('.tooltip').tooltip();

    $('input.named-place').autocomplete({
	delay: 300,
	mustMatch: true,
	source: "/sites/autocomplete_geoname",
	select: function(event, ui) {
	    $(event.target).closest('fieldset').find('.named-place-id').val(ui.item.id);
	}
    });
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
