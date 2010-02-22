document.observe("dom:loaded", function() {

	// initially loads gmaps
	if(GBrowserIsCompatible()) {
		Map.display();
	}
	
	// horizontal slider control for samplerate in maps
	if(($('sample_rate_slide') != undefined) && (Map.options.tracks.length > 0)) {
		new Control.Slider('sample_rate_handle', 'sample_rate_slide', {
			range: $R(1, 9),
			values: [1, 3, 5, 7, 9],
			sliderValue: 5, // won't work if set to 0 due to a bug(?) in script.aculo.us
			onSlide: function(rate) { $('sample_rate').innerHTML = 'Rate: ' + rate },
			onChange: function(rate) {
				$('sample_rate').innerHTML = 'Rate: ' + rate
				Map.reload_map_routes(rate);
			}
		});
	}

});

var Map = new Object();

Map.Methods = {
	points: [],
	track_points: new Array(),
	map: null, // Default map value
	initialized: false,
	current_point: null,
	options: {
		colors: ['0000ff', '00ff00', 'ff00ff', 'ff0000', 'ffff00', '00ffff'], // Colors for the different tracks
		sample_rate: 5, // Default samplerate for points
		tracks: [], // Which tracks to display
		track_version: 1,
		zoom_level: 4,
		center_lat: 61.845, // Swedens center latitude
		center_long: 17.7, // Swedens center longitude
		distance: false, // Don´t view distance as default
		distance_prefix: "", // Extends the id of the distance element, default is track_(id)
		map_element: "map_canvas", //Default map element
		click_listener: false
	},
	
	set_options: function(options) {
		Object.extend(this.options, options || {});
	},
	
	_init: function(options) {
		this.set_options(options);
		this._init_map();
		this.initialized = true; // Mark as initialized
		if(this.options.click_listener){
			this.add_click_listener();
		}
	},
	
	display: function(options) {
		if(!this.initialized) this._init(options); // Check for is already initialized
		if(this.options.tracks.length == 0) {
			this._render_map();
		}
		this._render_tracks();
	},
	
	reload_map_routes: function(rate){
		if(this.initialized){
			this.options.sample_rate = rate;
			this._clear_map_from_overlays();
			this._render_tracks();
		}
		else {
			
		}
	},
	
	_render_tracks: function(){
		for(var i = 0; i < this.options.tracks.length; i++) {
			this._load_track_points(this.options.tracks[i], i);
		}
	},
	
	_render_map: function() {
		var center = new GLatLng(this.options.center_lat, this.options.center_long);
		this.map.setCenter(center, this.options.zoom_level);
	},
	
	_load_track_points: function(track, index) {
		GDownloadUrl("/tracks/" + track + "/points.js?rate=" + this.options.sample_rate + "&version=" + this.options.track_version, function(data, responseCode) {
			var json_points = eval("(" + data + ")");
			Map.track_points = new Array();
			
			for(var i = 0; i < json_points.length; i++) {
				Map.track_points[i] = new Object();
				Map.track_points[i]['latitude'] = json_points[i]['point']['latitude'];
				Map.track_points[i]['longitude'] = json_points[i]['point']['longitude'];
			}
			Map._add_route(index);
			Map.points = Map.points.concat(Map.track_points);
			Map._set_center_point_and_zoom_level();
			if(Map.options.distance){
				Map._render_distance(index);
			}
		});
	},
	
	_add_marker: function(point) {
		var point = new GLatLng(point["latitude"], point["longitude"]);
		this.map.addOverlay(new GMarker(point));
	},

	_set_center_point_and_zoom_level: function() {
		var bounds = new GLatLngBounds();
		for (var i=0; i < this.points.length; i++) {
			var point = new GLatLng(this.points[i]["latitude"], this.points[i]["longitude"]);
			bounds.extend(point);
		}
		this.map.setCenter(bounds.getCenter(), this.map.getBoundsZoomLevel(bounds));
	},
	
	_add_route: function(index) {
		var line = new Array();
		for (var i = 0; i < this.track_points.length; i++) {
			line[i] = new GLatLng(this.track_points[i]["latitude"], this.track_points[i]["longitude"]);
		}
		var polyline = new GPolyline(line, "#" + this.options.colors[index], 3);
		this.map.addOverlay(polyline);
	},
	
	_clear_map_from_overlays: function() {
		this.map.clearOverlays() 
	},
	
	_init_map: function () {
		var gmap = new GMap2(document.getElementById(this.options.map_element));
		gmap.setUIToDefault();
		gmap.addMapType(G_SATELLITE_3D_MAP);
		gmap.addControl(new GLargeMapControl3D());
		this.map = gmap;
	},
	
	_render_distance: function(index) {
		var element = this.options.distance_prefix + 'track_' + (index + 1);
		$(element).innerHTML = Math.round((this._calculate_distance()/1000)*100)/100;
	},

	_calculate_distance: function() {
		var line = new Array();
		var distance = null;
		for (var i = 0; i < this.track_points.length; i++) {
			line[i] = new GLatLng(this.track_points[i]["latitude"], this.track_points[i]["longitude"]);
			if (i > 0) {
				distance += line[i].distanceFrom(line[i-1]);
			}
		}
		return distance;
	}
}
Object.extend(Map, Map.Methods);


Map.CreateMethods = {
	
	add_click_listener: function(options) {
		if(!this.initialized) throw "Map must be initilized first"; // Check for is already initialized
		GEvent.addListener(this.map, "click", function(overlay, point) { 
			Map.add_marker_to_map(point);
			Map.track_points.push(point);
		});
	},
	
	add_marker_to_map: function(point) {
		var marker = new GMarker(point);
		GEvent.addListener(marker, 'click', function() {
			var marker_html = "<div><p><span class=\"bold\">Longitude:</span> "+point.lng()+"</p>";
			marker_html += "<p><span class=\"bold\">Latitude:</span> "+point.lat()+"</p></div>";
			marker.openInfoWindowHtml(marker_html);
		});
		this._insert_hidden_fields(point);
		this.map.addOverlay(marker);
	},
	
	remove_last_point: function() {
		$('new_tracksegment_points').update("");
		this.track_points.splice(this.track_points.length-1,1);
		this.current_point = null;
		this._clear_map_from_overlays();
		this._reload_markers();
	},
	
	_reload_markers: function() {
		for(var i = 0; i < this.track_points.length; i++){
			this.add_marker_to_map(this.track_points[i]);
		}
	},
	
	_insert_hidden_fields: function(point) {
		$('new_tracksegment_points').insert(new Element("input", {type: "hidden", name: "points[][lat]", value: point.lat()}));
		$('new_tracksegment_points').insert(new Element("input", {type: "hidden", name: "points[][lng]", value: point.lng()}));
		this._set_elevation_field(point);
		
		if(this.current_point != null) {
			var polyline = new GPolyline([this.current_point, point], "#0000ff", 3);
			this.map.addOverlay(polyline);
		}
		this.current_point = point;
	},
	
	_set_elevation_field: function(point) {
		var url = "http://ws.geonames.org/gtopo30JSON?lat=" + point.lat() + "&lng=" + point.lng();
		GDownloadUrl(url, function(data, responseCode) {
			var json_info = eval("(" + data + ")");
			$('new_tracksegment_points').insert(new Element("input", {type: "hidden", name: "points[][ele]", value: json_info['gtopo30']}));
		});
	}
}

Object.extend(Map, Map.CreateMethods);