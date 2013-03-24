$(function() {
	$(".trainings_show p.toggle_new_race_form a").click(function(event) {
		$(this).parent().siblings("fieldset").toggle("fast");
		event.preventDefault();
	});
	
	$("a.toggle_event").on("click", function(event) {
		$(this).parent().siblings(".new_event").toggle("fast");
		event.preventDefault();
	});
});