(function($) {
	 Controller = Backbone.Router.extend({
		routes: {
			"users/:user/trainings/new": 	"manageTraining"
		}
	});
})(jQuery);