$(function() {
	$(".sessions_new div.login a.login").click(function(event) {
		event.preventDefault();
		$(this).parents("div.login").hide().siblings("div.login").show();
	});
});