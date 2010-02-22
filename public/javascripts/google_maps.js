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

function load_segment_points(track_id, color, sample_rate) {
	GDownloadUrl("/tracks/" + track_id + "/points.gpx?rate=" + sample_rate, function(data, responseCode) {
		
		//resets the segment distances
		if ($('track_distance') != undefined) {
			$('track_distance').innerHTML = "";
		}
		
		var xml = GXml.parse(data);
		var tracksegments = xml.documentElement.getElementsByTagName('trkseg');
		var total_distance = 0;
		for(var i = 0; i < tracksegments.length; i++) {
			var points = new Array();
			
			var xml_points = tracksegments[i].getElementsByTagName('trkpt');
			
			for(var k = 0; k < xml_points.length; k++) {
				points[k] = new Object();
				points[k]['latitude'] = xml_points[k].getAttribute("lat");
				points[k]['longitude'] = xml_points[k].getAttribute("lon");
			}
			this.points = this.points.concat(points);
			set_start_point(points[0]);
			set_end_point(points[k-1]);
			add_route(points, color);
			var distance = calculate_distance(points);
			total_distance += distance;
			render_track_distance(distance, i);
			set_center_point_and_zoom_level(this.points);
		}
		render_track_distance(total_distance, null);
	});
}

function set_start_point(point) {
	var point = new GLatLng(point["latitude"], point["longitude"]);
	this.gmap.addOverlay(new GMarker(point));
}

function set_end_point(point) {
	var point = new GLatLng(point["latitude"], point["longitude"]);
	this.gmap.addOverlay(new GMarker(point));
}

function set_center_point_and_zoom_level(points) {
	var bounds = new GLatLngBounds();
	for (var i=0; i < points.length; i++) {
		var point = new GLatLng(points[i]["latitude"], points[i]["longitude"]);
		bounds.extend(point);
	}
	this.gmap.setCenter(bounds.getCenter(), this.gmap.getBoundsZoomLevel(bounds));
}

function add_route(points, color) {
	var line = new Array();
	for (var i = 0; i < points.length; i++) {
		line[i] = new GLatLng(points[i]["latitude"], points[i]["longitude"]);
	}
	var polyline = new GPolyline(line, "#" + color, 3);
	this.gmap.addOverlay(polyline);
}

function render_track_distance(distance, i) {
	if ($('track_distance') != undefined) {
		if(i != null) {
			$('track_distance').innerHTML += 'Segment ' + (i+1) + ' is: ' + Math.round((distance/1000)*100)/100 + " km.<br />";
		}
		else {
			$('track_distance').innerHTML += 'Total: ' + Math.round((distance/1000)*100)/100 + " km.<br />";
		}
	}
}

function calculate_distance(points) {
	var line = new Array();
	var distance = null;
	for (var i = 0; i < points.length; i++) {
		line[i] = new GLatLng(points[i]["latitude"], points[i]["longitude"]);
		if (i > 0) {
			distance += line[i].distanceFrom(line[i-1]);
		}
	}
	return distance;
}


function init_map() {
	var gmap = new GMap2(document.getElementById("map_canvas"));
	gmap.setUIToDefault();
	gmap.addMapType(G_SATELLITE_3D_MAP);
	gmap.addControl(new GLargeMapControl3D());
	this.gmap = gmap;
}

function reload_map_overlays(rate) {
	clear_map_from_overlays();
	load_segment_points(rate);
}

function clear_map_from_overlays() {
	this.gmap.clearOverlays() 
}