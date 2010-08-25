APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :rocky => ["prototype/prototype", "prototype/scriptaculous", "prototype/modalbox", "prototype/tooltips", "prototype/application", "prototype/tracks", "prototype/users", "prototype/comments", "prototype/trainings"]
ActionView::Helpers::AssetTagHelper.register_javascript_expansion :rambo => ["jquery-1.4.2.min", "initializer", "jquery-ui-1.8.4.custom.min", "jquery.form", "highcharts", "charts", "utilities", "jquery.popup", "application", "tabs", "comments", "users", "trainings", "tracks", "sessions"]

ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :rambo => ["global/tabs", "global/buttons", "global/jquery-ui-1.8.4.custom", "global/jquery.popup", "side_modules/recent_records", "trainings/show", "tracks/show", "users/track_statistics", "users/events", "sessions/new"]

Paperclip.interpolates :version do |attachment, style|
  attachment.instance.version
end