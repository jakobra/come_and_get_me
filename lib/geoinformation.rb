module Geoinformation
  require 'open-uri'
  
  def self.location(remote_ip)
    @location ||= get_location(remote_ip)
  end
  
  private
  # Returns RegionName of geolocation
  def self.get_location(remote_ip)
    if Rails.env == "development"
      ip = "85.224.104.52"
      #ip = "194.237.179.38"
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