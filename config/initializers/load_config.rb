APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :rambo => ["jquery-1.4.2.min", "initializer", "jquery-ui-1.8.4.custom.min", "jquery.form", "highcharts", "charts", "utilities", "jquery.popup", "application", "tabs", "comments", "users", "trainings", "tracks", "sessions", "races"]

Paperclip.interpolates :version do |attachment, style|
  attachment.instance.version
end