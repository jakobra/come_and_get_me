$(function() {
	$("div.races.fields select.tracks").on("click", function(event) {
		var select = $(this);
		select.parent().next().children("input").removeAttr("readonly").val("");
		$.each(tracks.json_list, function(key,track){
			if (track.id.toString() == select.val()) {
				select.parent().next().children("input").attr("readonly", "").val(track.distance);
				return false;
			}
		});
	});
});
