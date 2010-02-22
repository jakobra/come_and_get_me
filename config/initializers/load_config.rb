APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :rambo => ["prototype", "scriptaculous", "modalbox", "application"]

Paperclip.interpolates :version do |attachment, style|
  attachment.instance.version
end