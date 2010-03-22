module Geolocation
  require 'open-uri'
  
  def self.remote_ip(remote_ip = nil)
    @remote_ip = remote_ip
  end
  
  def self.remote_ip
    @remote_ip
  end
  
  def self.get_country
    geolocation['CountryName']
  end
  
  def self.get_county(remote_ip)
    geolocation(remote_ip)['RegionName']
  end
  
  def self.get_city(remote_ip)
    geolocation(remote_ip)['City']
  end
  
  def self.geolocation(remote_ip)
    @geolocation ||= get_geolocation(remote_ip)
  end
  
  # Translate so that you can compare Countys with RegionName from geolocation()
  def self.translated(geo_object)
    geo_object = geo_object.gsub(/Ö/, 'O')
    geo_object = geo_object.gsub(/ö/, 'o')
    geo_object = geo_object.gsub(/[ÅÄ]/, 'A')
    geo_object = geo_object.gsub(/[åä]/, 'a')
  end
  
  def self.find_closest_area(remote_ip)
    if geolocation(remote_ip)['CountryName'] == "Sweden"
      county = County.find_by_geolocation(remote_ip)
      municipality = county.municipalities.find_by_geolocation(remote_ip)
      municipality.blank? ? county : municipality
    else
      nil
    end
  end
  
  private
  # Returns RegionName of geolocation
  def self.get_geolocation(remote_ip)
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