module Geolocation
  require 'open-uri'
  
  def self.get_country
    geolocation['CountryName']
  end
  
  def self.get_county
    geolocation['RegionName']
  end
  
  def self.get_city
    geolocation['City']
  end
  
  def self.geolocation
    @geolocation ||= get_geolocation
  end
  
  # Translate so that you can compare Countys with RegionName from geolocation()
  def self.translated(geo_object)
    geo_object = geo_object.gsub(/Ö/, 'O')
    geo_object = geo_object.gsub(/ö/, 'o')
    geo_object = geo_object.gsub(/[ÅÄ]/, 'A')
    geo_object = geo_object.gsub(/[åä]/, 'a')
  end
  
  def self.find_closest_area
    county = County.find_by_geolocation
    municipality = county.municipalities.find_by_geolocation
    municipality.blank? ? county : municipality
  end
  
  private
  # Returns RegionName of geolocation
  def self.get_geolocation
    #ip = remote_ip
    ip = "85.224.104.52"
    url = "http://ipinfodb.com/ip_query.php?ip=#{ip}&output=json"
    Rails.logger.info "Getting IP-info"
    json = open(url, "UserAgent" => "Ruby-Wget").read
    result = JSON.parse(json)
  end
    
end