Event.observe(window, 'load', function() {
	
	$(document).observe('click', function(e){
		var element = e.element();
		if (element.match('.tracks_show a.toggle_history')) {
			Effect.toggle(element.next('ul.track_history'), 'blind');
			element.hide();
			if (element.match('a.show'))
				element.next("a.hide").show();
			else
				element.previous("a.show").show();
			e.stop();
		}
		else if (element.match('.tracks_new a.remove_last_point') || element.match('.tracks_edit a.remove_last_point')) {
			Map.remove_last_point();
			e.stop();
		}
		else if (element.match('input[name=gender]')) {
			var parent_element = element.up('div.wrapper')
			parent_element.select('input').invoke('removeAttribute', "checked");
			element.writeAttribute("checked", "checked");
			get_track_records(parent_element);
		}
	});
	
	$(document).observe('change', function(e){
		var element = e.element();
		if (element.match('select.select_track_event')) {
			var parent_element = element.up('div.wrapper');
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
	var form = element.down('form.track_records');
	form.request({
		onSuccess: function(transport){
			element.update(transport.responseText);
		}
	});
}
