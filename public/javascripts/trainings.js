Event.observe(window, 'load', function() {

	$(document).observe('click', function(e){
		var element = e.element();
		if (element.match('.trainings_show p.toggle_new_race_form a')) {
			Effect.toggle(element.up().next('fieldset'), 'blind');
			e.stop();
		}
	});
});