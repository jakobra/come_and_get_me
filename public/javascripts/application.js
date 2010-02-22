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
});

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
