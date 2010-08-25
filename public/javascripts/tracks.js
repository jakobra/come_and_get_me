$(function() {
	$('.tracks_show a.toggle_history.show').click(function(event) {
		$(this).parent().children("ul.track_history").slideDown();
		$(this).hide();
		$(this).parent().children("a.hide").show();
		event.preventDefault();
	});
	
	$('.tracks_show a.toggle_history.hide').click(function(event) {
		$(this).parent().children("ul.track_history").slideUp();
		$(this).hide();
		$(this).parent().children("a.show").show();
		event.preventDefault();
	});
	
	$('input[name=gender]').live("click", function(event) {
		$(this).siblings("input").removeAttr("checked");
		$(this).attr("checked", "checked");
		get_track_records($(this).parents("div.wrapper"));
		event.preventDefault();
	});
	
	$('select.select_track_event').live("change", function(event) {
		get_track_records($(this).parents("div.wrapper"));
	});
	
	$('form.tracks select').live("change", function(event) {
		var form = $(this).parents("form.tracks");
		if($(this).attr("name") == "county")
			$(this).siblings("select").children().eq(0).attr("selected", "selected");
		
		$.get(form.attr("action"), form.serialize(), function(data) {
			form.parents("div.content").html(data);
		});
	});
	
	$('a.remove_last_point').click(function(event) {
		event.preventDefault();
		Map.remove_last_point();
	});
	
});

function get_track_records(element) {
	var form = element.children('.track_records_options').children("form.track_records");
	$.get(form.attr("action"), form.serialize(), function(data) {
		element.html(data);
	});
}