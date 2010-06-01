Event.observe(window, 'load', function() {
	$(document).observe('click', function(e){
		var element = e.element();
		if (element.match('a.answer_comment') || element.match('a.new_comment')) {
			var href = element.readAttribute('href');
			new Ajax.Request(href, {
				method: 'get',
				onComplete: function(transport) {
					if (200 == transport.status) {
						eval(transport.responseText);
					}
				}
			});
			e.stop();
		}
		else if (element.match('a.report_comment')) {
			var href = element.readAttribute('href');
			new Ajax.Request(href, {
				method: 'get',
				onComplete: function(transport) {
					if (200 == transport.status) {
						alert(transport.responseText);
					}
				}
			});
			e.stop();
		}
		else if (element.match('a.edit_comment')) {
			var href = element.readAttribute('href');
			new Ajax.Request(href, {
				method: 'get',
				onComplete: function(transport) {
					if (200 == transport.status) {
						eval(transport.responseText);
					}
				}
			});
			e.stop();
		}
		else if (element.match('input.edit_comment') || element.match('input.new_comment')) {
			var action = element.up('form').readAttribute('action');
			element.up('form').request({
				onSuccess: function(transport){ eval(transport.responseText) }
			});
			e.stop();
		}
	});
});