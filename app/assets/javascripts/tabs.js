$(function() {
	$('div.recent_records div.tabs a').on("click", function(event) {
		var target = $(this).parents('div.recent_records');
		target.load($(this).attr('href'), function(data) {
		  target.children().unwrap();
		});
		event.preventDefault();
	});
});