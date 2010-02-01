function load_segment_points(sample_rate) {
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
			set_start_point(points[0]);
			set_end_point(points[k-1]);
			add_route(points);
			set_center_point_and_zoom_level(points);
			var distance = calculate_distance(points);
			total_distance += distance;
			render_track_distance(distance, i);
		}
		render_track_distance(total_distance, null);
	});
}

function set_start_point(point) {
	var point = new GLatLng(point["latitude"], point["longitude"]);
	this.map.addOverlay(new GMarker(point));
}

function set_end_point(point) {
	var point = new GLatLng(point["latitude"], point["longitude"]);
	this.map.addOverlay(new GMarker(point));
}

function set_center_point_and_zoom_level(points) {
	var bounds = new GLatLngBounds();
	for (var i=0; i < points.length; i++) {
		var point = new GLatLng(points[i]["latitude"], points[i]["longitude"]);
		bounds.extend(point);
	}
	this.map.setCenter(bounds.getCenter(), this.map.getBoundsZoomLevel(bounds));
}

function add_route(points) {
	var line = new Array();
	for (var i = 0; i < points.length; i++) {
		line[i] = new GLatLng(points[i]["latitude"], points[i]["longitude"]);
	}
	var polyline = new GPolyline(line, "#fb006a", 3);
	this.map.addOverlay(polyline);
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
	var map = new GMap2(document.getElementById("map_canvas"));
	map.setUIToDefault();
	map.addMapType(G_SATELLITE_3D_MAP);
	map.addControl(new GLargeMapControl3D());
	this.map = map;
	load_segment_points("");
}

function reload_map_overlays(rate) {
	clear_map_from_overlays();
	load_segment_points(rate);
}

function clear_map_from_overlays() {
	this.map.clearOverlays() 
}