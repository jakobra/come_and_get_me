$(function() {
	$("div.user_track_statistics a.order").live("click", function(event) {
		$(this).parents("table").load($(this).attr('href'));
		event.preventDefault();
	});
	
	$(".toggle_user_statistics").click(function(event) {
		$(this).parent().children("form").slideToggle();
		event.preventDefault();
	});
	
	$(".user_statistics a.stat_link").click(function(event) {
		$(this).parent().children("div.statistics").load($(this).attr("href"));
		$(this).parent().children("h4").children("span").remove();
		event.preventDefault();
	});
	
	$("form.custom_user_stat").ajaxForm({
		success: function(responseText, statusText, xhr, form) {
			form.parent().children("div.statistics").html(responseText);
			form.parent().children("h4").children("span").remove();
		}
	});
});