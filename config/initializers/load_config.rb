APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

Paperclip.interpolates :version do |attachment, style|
  attachment.instance.version
end