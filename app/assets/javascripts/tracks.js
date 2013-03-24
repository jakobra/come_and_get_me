$(function() {
	$('.tracks_show a.toggle_history').click(function(event) {
		event.preventDefault();
		$(this).parent().children("ul.track_history").slideToggle();
		$(this).hide();
		$(this).siblings("a").show();
	});
	
	$('input[name=gender]').on("click", function(event) {
		$(this).siblings("input").removeAttr("checked");
		$(this).attr("checked", "checked");
		get_track_records($(this).parents("div.wrapper"));
		event.preventDefault();
	});
	
	$('select.select_track_event').on("change", function(event) {
		get_track_records($(this).parents("div.wrapper"));
	});
	
	$('form.tracks select').on("change", function(event) {
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
	
	$('form.form input[type=submit]').click(function(event) {
		$('#overlay').addClass("black").css({ 'opacity': 0, 'display': 'block' }).fadeTo(250, 0.8);
		modal_box.insert($('#popup').addClass("center-vertical"), 250, $("div.loader").html());
	});
});

function get_track_records(element) {
	var form = element.children('.track_records_options').children("form.track_records");
	$.get(form.attr("action"), form.serialize(), function(data) {
		element.html(data);
	});
}