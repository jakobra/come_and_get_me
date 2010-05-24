Event.observe(window, 'load', function() {

	$(document).observe('click', function(e){
		var element = e.element();
		if (element.match('.toggle_user_statistics')) {
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
	});
});