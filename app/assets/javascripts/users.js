$(function() {
	$("div.user_track_statistics a.order").on("click", function(event) {
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
});