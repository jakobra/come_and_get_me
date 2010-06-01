APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :rambo => ["prototype", "scriptaculous", "modalbox", "tooltips", "application", "tracks", "users", "comments"]
ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :rambo => ["global/tabs", "global/buttons", "side_modules/recent_records", "trainings/show"]

Paperclip.interpolates :version do |attachment, style|
  attachment.instance.version
end