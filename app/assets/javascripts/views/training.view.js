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
	
	RaceFormView = Backbone.View.extend({
		events: {
			'click a.view_all_tracks' : 'view_all_tracks',
			'click a.toggle_event' : 'toggle_new_event',
			'click a.toggle_note' : 'toggle_note',
			'change select.tracks' : 'update_distance_field',
			'click a.remove_race_fields' : 'destroy'
		},
		
		initialize: function(options) {
			this.index = options.index;
		},
		
		render: function() {
			var tmplMarkup = $('#race_form_template').html();
			var compiledTmpl = _.template(tmplMarkup, { index : this.index });
			this.setElement($(compiledTmpl));
			return this.$el;
		},
		
		destroy: function(event) {
			event.preventDefault();
			this.$el.remove();
		},

		view_all_tracks: function(event) {
			event.preventDefault();
			if(!this.model.allTracks.loaded) {
				var self = this;
				this.model.allTracks.fetch({success: function() {
					self.model.allTracks.loaded = true;
					self.replace_with_all_tracks();
				}});
			} else {
				this.replace_with_all_tracks();
			}
		},

		update_distance_field: function() {
			var id = this.$("select.tracks").val();
			if(id) {
				var track = this.model.allTracks.loaded ? this.model.allTracks.get(id) : this.model.localTracks.get(id);
				this.$("input.distance_field").val(track.get('distance'));
				this.$("input.distance_field").attr('readonly', true);
			}
		},
		
		replace_with_all_tracks: function() {
			var tmplMarkup = '{{for(index = 0; index < tracks.length; index++) { }}<option value="{{=tracks.at(index).get("id")}}">{{=tracks.at(index).get("title")}}</option>{{ } }}';
			var compiledTmpl = _.template(tmplMarkup, { tracks : this.model.allTracks });
			this.$("select.tracks").html(compiledTmpl);
			//console.log(compiledTmpl);
		},
		
		toggle_new_event: function(event) {
			event.preventDefault();
			this.$(".new_event").toggle("fast");
		},
         
		toggle_note: function(event) {
			event.preventDefault();
			this.$(".new_note").toggle("fast");
		}
	});
})(jQuery, _);