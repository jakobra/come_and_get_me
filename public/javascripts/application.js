// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Event.observe(window, 'load', function() {
	if($('track_submit') != undefined ) {
		$('track_submit').observe('click', function(event) {
			show_loading_box();
			add_hide_observer();
		});
	}
	
	if($$('.view_new_comment_form').length != 0 ) {
		$$('.view_new_comment_form').each(function (element) {
			add_show_comment_form_observer(element, ".new_comment_box");
		});
	}
	
	if($$('.view_edit_comment_form').length != 0 ) {
		$$('.view_edit_comment_form').each(function (element) {
			add_show_comment_form_observer(element, ".edit_comment_box");
		});
	}
	
	render_tooltips();
	
	$(document).observe('click', function(e){
		var element = e.element();
		if (element.match('.toggle_comment')) { 
			element.up().next('.new_comment').toggle();
			e.stop();
		}
		else if (element.match('.toggle_event')) { 
			element.up().next('.new_event').toggle();
			e.stop();
		}
		else if (element.match('.toggle_user_statistics')) {
			Effect.toggle(element.up().down('form'), 'blind')
			e.stop();
		}
		else if (element.match('.user_statistics a.stat_link')) {
			var href = element.readAttribute('href');
			new Ajax.Request(href, {
				method: 'get',
				onComplete: function(transport) {
					if (200 == transport.status) {
						element.next('div').update(transport.responseText);
						element.previous('h4').down('span').remove();
					}
				}
			});
			e.stop();
		}
		else if (element.match('div.user_track_statistics a.order')) {
			var href = element.readAttribute('href');
			new Ajax.Request(href, {
				onComplete: function(transport) {
					if (200 == transport.status) {
						element.up('table').update(transport.responseText);
					}
				}
			});
			e.stop();
		}
		else if (element.match('input[name=gender]')) {
			var parent_element = element.up('div.track_records_options')
			parent_element.select('input').invoke('removeAttribute', "checked");
			element.writeAttribute("checked", "checked");
			get_track_records(parent_element);
		}
		else if (element.match('.change_local_area')) {
			element.up().next(".area_select").show();
			event.stop();
		}
	});
	
	$(document).observe('change', function(e){
		var element = e.element();
		if (element.match('select.select_track_event')) {
			var parent_element = element.up('div.track_records_options');
			get_track_records(parent_element);
			e.stop();
		}
		else if (element.match('select.county')) {
			var href = "/home/local_area/?county_id=" + element.value;
			new Ajax.Request(href, {
				method: 'get',
				onComplete: function(transport) {
					if (200 == transport.status) {
						element.up().up().replace(transport.responseText);
					}
				}
			});
			e.stop();
		}
		else if (element.match('select.municipality')) {
			var href = "/home/local_area/?municipality_id=" + element.value;
			new Ajax.Request(href, {
				method: 'get',
				onComplete: function(transport) {
					if (200 == transport.status) {
						element.up().up().replace(transport.responseText);
					}
				}
			});
			e.stop();
		}
	});
	
});

function get_track_records(element) {
	var href = document.URL + "?";
	
	// Event selector
	if(element.down('select.select_track_event') != undefined && element.down('select.select_track_event').value != "") {
		href += "event_id=" + element.down('select.select_track_event').value + "&";
	}
	
	// Gender selector
	if(element.down('input[checked=checked]').value != "-1") {
		href += "gender=" + element.down('input[checked=checked]').value;
	}
	new Ajax.Request(href, {
		method: 'get',
		onComplete: function(transport) {
			if (200 == transport.status) {
				element.next('ol').update(transport.responseText);
			}
		}
	});
}

function render_tooltips() {
	$$("img.info").each( function(img) {
		new Tooltip(img);
	});
}

function add_show_comment_form_observer(el, box) {
	$(el).observe('click', function(event) {
		show_comment_form(this.up().down(box));
		add_hide_observer();
		event.stop();
	});
}

function add_hide_observer() {
	if($$('.MB_close').length != 0 ) {
		$$('.MB_close').each(function (el) {
			$(el).observe('click', function(event) {
				hide_box();
				event.stop();
			});
		});
	}
}

function show_loading_box() {
	Modalbox.show($$('.modalbox_content')[0], {width: 300, transitions: false, overlayClose:false});
}

function show_comment_form(box) {
	Modalbox.show(box, {width: 400, transitions: false, overlayClose:true, overlayOpacity: 0.0});
}

function hide_box() {
	Modalbox.hide();
	return false;
}

function remove_fields(link) {
	$(link).previous("input[type=hidden]").value = "1";
	$(link).up(".fields").hide();
}

function add_fields(link, association, content) {
	var new_id = new Date().getTime();
	var regexp = RegExp("new_" + association, "g");
	$(link).up().insert({before: content.replace(regexp, new_id)});
	render_tooltips();
}
