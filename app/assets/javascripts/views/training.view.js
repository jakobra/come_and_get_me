(function($, _) {
	TrainingView = Backbone.View.extend({
		events: {
			'click a.add_fields' : 'add_race_fields'
		},
		
		initialize: function(){
			this.model.allTracks = new TracksCollection();
			this.raceFormViews = [];
			var self = this;
			this.$(".races").each(function(index, value){
				var form = new RaceFormView({model: self.model, index: index});
				form.setElement($(this));
				self.raceFormViews.push(form);
			});
		},
		
		add_race_fields: function(event) {
			event.preventDefault();
			var index = this.raceFormViews.length;
			var view = new RaceFormView({model: this.model, index: index});
			this.raceFormViews.push(view);
			$('.races_fields').append(view.render());
		}
	});
})(jQuery, _);