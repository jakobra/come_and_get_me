var Map = new Object();

Map.Methods = {
	points: [],
	map: null, // Default map value
	initialized: false,
	current_point: null,
	overlays: [],
	options: {
		color: '0000ff', // Colors for the different tracks
		track: null, // Which track to display
		zoom_level: 4,
		center_lat: 61.845, // Swedens center latitude
		center_long: 17.7, // Swedens center longitude
		click_listener: false,
		points_reference_element: "tracksegments",
		map_element: "map_canvas" //Default map element
	},
	
	set_options: function(options) {
		 jQuery.extend(this.options, options || {});
	},
	
	_init: function(options) {
		this.set_options(options);
		
		this.map = new google.maps.Map(document.getElementById(this.options.map_element));
		this.map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
		
		this.initialized = true; // Mark as initialized
		
		if(this.options.click_listener){
			this.add_click_listener();
		}
	},
	
	display: function(options) {
		if(!this.initialized) this._init(options);
		if(this.options.track == null) {
			this._render_map();
		} else {
			this._load_track_points(this.options.track);
		}
	},
	
	_render_map: function() {
		var center = new google.maps.LatLng(this.options.center_lat, this.options.center_long);
		this.map.setCenter(center);
		this.map.setZoom(this.options.zoom_level);
	},
	
	_load_track_points: function(track_id) {
		$.get("/tracks/" + track_id + "/points.js?rate=" + this.options.sample_rate, function(data) {
			var json_points = eval("(" + data + ")");
			Map.points = new Array();
			
			for(var i = 0; i < json_points.length; i++) {
				Map.points[i] = new Object();
				Map.points[i]['latitude'] = json_points[i]['latitude'];
				Map.points[i]['longitude'] = json_points[i]['longitude'];
			}
			Map._add_route();
			Map._set_center_point_and_zoom_level();
		});
	},

	_set_center_point_and_zoom_level: function() {
		var polylineBounds = new google.maps.LatLngBounds();
		for (var i=0; i < this.points.length; i++) {
			var point = new google.maps.LatLng(this.points[i]["latitude"], this.points[i]["longitude"]);
			polylineBounds.extend(point);
		}
		this.map.setCenter(polylineBounds.getCenter());
		this.map.fitBounds(polylineBounds);
	},
	
	_add_route: function() {
		var line = new Array();
		
		for (var i = 0; i < this.points.length; i++) {
			line[i] = new google.maps.LatLng(this.points[i]["latitude"], this.points[i]["longitude"]);
		}
		
		this._render_polyline(line);
	},
	
	_render_polyline: function(polyline) {
		var line = new google.maps.Polyline({path:polyline, strokeColor: "#" + this.options.color, strokeWeight: 3, strokeOpacity: 0.5});
		line.setMap(this.map);
		Map.overlays.push(line);
	}
}
jQuery.extend(Map, Map.Methods);

Map.CreateMethods = {
	
	add_click_listener: function(options) {
		if(!this.initialized) throw "Map must be initilized first"; // Check for is already initialized
		//this._reload_markers();
		google.maps.event.addListener(Map.map, 'click', function(event) {
			Map.add_marker_to_map(event.latLng);
			Map.points.push(event.latLng);
		});
	},
	
	add_marker_to_map: function(point) {
		var marker = new google.maps.Marker({
			position: point, 
			map: Map.map
		});
		Map.overlays.push(marker);
		if(this.current_point != null) {
			this._render_polyline([this.current_point, point]);
		}
		
		this.current_point = point;
		this._insert_hidden_fields();
	},
	
	_insert_hidden_fields: function(point) {
		// Url to get the elevation ... never used
		var url = "http://ws.geonames.org/gtopo30JSON?lat=" + this.current_point.lat() + "&lng=" + this.current_point.lng();
		
		var fields = '<input type="hidden" id="track_tracksegments_attributes_0_points_attributes_new_points_latitude" name="track[tracksegments_attributes][0][points_attributes][new_points][latitude]" value="' + this.current_point.lat() + '" />';
		fields += '<input type="hidden" id="track_tracksegments_attributes_0_points_attributes_new_points_longitude" name="track[tracksegments_attributes][0][points_attributes][new_points][longitude]" value="' + this.current_point.lng() + '" />';
		fields += '<input type="hidden" id="track_tracksegments_attributes_0_points_attributes_new_points_elevation" name="track[tracksegments_attributes][0][points_attributes][new_points][elevation]" value="0" />';
		var element = $("div." + this.options.points_reference_element);
		
		var new_id = new Date().getTime();
		var regexp = RegExp("new_points", "g");
		element.children("div").append(fields.replace(regexp, new_id));
	},
	
	remove_last_point: function() {
		var element = $("div." + this.options.points_reference_element);
		element.children("div").html("");
		
		for (i in this.overlays) {
			this.overlays[i].setMap(null);
		}
		
		this.points.splice(this.points.length-1,1);
		this.current_point = null;
		for(i in this.points){
			this.add_marker_to_map(this.points[i]);
		}
	}
}

jQuery.extend(Map, Map.CreateMethods);