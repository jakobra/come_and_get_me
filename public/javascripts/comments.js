$(function() {
	$("a.report_comment").live("click", function(event) {
		$.get($(this).attr("href"), function(data) {
			alert(data);
		});
		event.preventDefault();
	});
});

