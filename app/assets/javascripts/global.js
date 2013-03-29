$(function() {
	$("form input[type=submit]").click(function(event) {
		// removes hidden fields before submit
		$(this).parents("form").children("div.fields.hidden").remove();
	});
	
	$(".change_local_area").on("click", function(event) {
		// removes hidden fields before submit
		$(this).parent().siblings(".area_select").slideToggle();
		event.preventDefault();
	});
	
	$("select.county").on("change", function(event) {
		var href = "/home/local_area/?county_id=" + $(this).val();
		var target = $(this).parent().parent();
		target.load(href, function(data) {
		  target.children().unwrap();
		});
	});
	
	$("select.municipality").on("change", function(event) {
		var href = "/home/local_area/?municipality_id=" + $(this).val();
		var target = $(this).parent().parent();
		target.load(href, function(data) {
		  target.children().unwrap();
		});
	});
});