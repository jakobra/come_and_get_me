Event.observe(window, 'load', function() {
	
	$(document).observe('change', function(e){
		var element = e.element();
		if (element.match('select.select_track_event')) {
			var parent_element = element.up('div.track_records_options');
			get_track_records(parent_element);
			e.stop();
		}
		else if (element.match('form.tracks select')) {
			var form = element.up('form.tracks');
			if(element.match('select[name=county]')) {
				element.next().firstDescendant().selected = true;
			}
			form.request({
				onSuccess: function(transport){
					form.up("div.content").update(transport.responseText);
				}
			});
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
