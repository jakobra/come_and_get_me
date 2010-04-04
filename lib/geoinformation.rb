module Geoinformation
  require 'open-uri'
  
  def self.location(remote_ip)
    @location ||= get_location(remote_ip)
  end
  
  # Translate so that you can compare Countys with RegionName from geolocation()
  def self.translated(geo_object)
    geo_object = geo_object.gsub(/Ö/, 'O')
    geo_object = geo_object.gsub(/ö/, 'o')
    geo_object = geo_object.gsub(/[ÅÄ]/, 'A')
    geo_object = geo_object.gsub(/[åä]/, 'a')
  end
  
  private
  # Returns RegionName of geolocation
  def self.get_location(remote_ip)
    if RAILS_ENV == "development"
      ip = "85.224.104.52"
    else
      ip = remote_ip
    end
    url = "http://ipinfodb.com/ip_query.php?ip=#{ip}&output=json"
    Rails.logger.info "Getting IP-info"
    begin
      json = open(url, "UserAgent" => "Ruby-Wget").read
      result = JSON.parse(json)
    rescue
      result = {}
    end
    
    result
  end
  
end