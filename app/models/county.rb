class County < ActiveRecord::Base
  has_many :municipalities
  has_many :tracks, :through => :municipalities
  
  attr_accessible :name, :code, :numeric_code
  
  validates_presence_of :name, :code, :numeric_code
  
  def self.find_by_geolocation(remote_ip)
    if @counties.blank? and Geoinformation.location(remote_ip)['CountryName'] == "Sweden"
      @counties = self.all.reject do |c|
        AreaResolver.new(c.name, Geoinformation.location(remote_ip)['RegionName']).match?
      end
    end
    @counties.blank? ? nil : @counties.first
  end
  
end
