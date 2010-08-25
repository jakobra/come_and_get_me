$(function() {
	$(".trainings_show p.toggle_new_race_form a").click(function(event) {
		$(this).parent().siblings("fieldset").toggle("fast");
		event.preventDefault();
	});
	
	$("a.toggle_event").live("click", function(event) {
		$(this).parent().siblings(".new_event").toggle("fast");
		event.preventDefault();
	});
	
	$(".trainings_show form").ajaxForm({
		success: function(responseText, statusText, xhr, form) {
			form.parent().html(responseText);
		}
	});
});