class County < ActiveRecord::Base
  has_many :municipalities
  has_many :race_tracks, :through => :municipalities
  has_many :tracks, :through => :municipalities
  
  attr_accessible :name, :code, :numeric_code
  
  validates_presence_of :name, :code, :numeric_code
  
  def self.find_by_geolocation(remote_ip)
    if @counties.blank?
      @counties = self.all.reject do |c|
        Geolocation.translated(c.name) != Geolocation.get_county(remote_ip)
      end
    end
    @counties.first
  end
  
end
