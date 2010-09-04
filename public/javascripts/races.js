$(function() {
	$("div.races.fields select.tracks").live("click", function(event) {
		var select = $(this);
		select.parent().next().children("input").removeAttr("readonly").val("");
		$.each(tracks.json_list, function(key,track){
			console.log(track);
			if (track.track.id.toString() == select.val()) {
				select.parent().next().children("input").attr("readonly", "readonly").val(track.track.distance);
				return false;
			}
		});
	});
});
