(function() {
	TracksCollection = Backbone.Collection.extend({
		model: Track,
		url: "/tracks"
	});
})();