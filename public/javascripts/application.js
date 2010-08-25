$(function() {
	$("a[rel=popup]").popup();
	
	$(".toggle_note").live("click", function(event) {
		$(this).parent().siblings(".new_note").toggle();
		event.preventDefault();
	});
	
	$("a.remove_fields").live("click", function(event) {
		$(this).siblings("input[type=hidden]").attr("value", 1);
		$(this).parents(".fields").hide();
		event.preventDefault();
	});
	
	$("a.add_fields").click(function(event) {
		var new_id = new Date().getTime();
		var association = $(this).attr("class").split(/\s+/)[1];
		var regexp = RegExp("new_" + association, "g");
		
		var content = $(this).parent().next("div.fields").clone();
		var new_content = content.html().replace(regexp, new_id);
		content.html(new_content);
		
		content.removeClass("hidden");
		$(this).parent().before(content);
		event.preventDefault();
	});
	
	$("form input[type=submit]").click(function(event) {
		// removes hidden fields before submit
		$(this).parents("form").children("div.fields.hidden").remove();
	});
	
	$(".change_local_area").live("click", function(event) {
		// removes hidden fields before submit
		$(this).parent().siblings(".area_select").slideToggle();
		event.preventDefault();
	});
	
	$("select.county").live("change", function(event) {
		var href = "/home/local_area/?county_id=" + $(this).val();
		var target = $(this).parent().parent();
		target.load(href, function(data) {
		  target.children().unwrap();
		});
	});
	
	$("select.municipality").live("change", function(event) {
		var href = "/home/local_area/?municipality_id=" + $(this).val();
		var target = $(this).parent().parent();
		target.load(href, function(data) {
		  target.children().unwrap();
		});
	});
});