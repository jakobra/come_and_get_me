$(function() {
	$(".trainings_show p.toggle_new_race_form a").click(function(event) {
		$(this).parent().siblings("fieldset").toggle("fast");
		event.preventDefault();
	});
});