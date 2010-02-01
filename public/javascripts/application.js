// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

document.observe("dom:loaded", function() {
	// initially loads gmaps
	if(GBrowserIsCompatible()) {
		init_map();
	}
	
	// horizontal slider control for samplerate in maps
	new Control.Slider('sample_rate_handle', 'sample_rate_slide', {
		range: $R(1, 10),
		values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
		sliderValue: 5, // won't work if set to 0 due to a bug(?) in script.aculo.us
		onSlide: function(rate) { $('sample_rate').innerHTML = 'Rate: ' + rate },
		onChange: function(rate) {
			$('sample_rate').innerHTML = 'Rate: ' + rate
			reload_map_overlays(rate);
		}
	});
});
