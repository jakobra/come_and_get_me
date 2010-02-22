class County < ActiveRecord::Base
  has_many :municipalities
  has_many :race_tracks, :through => :municipalities
  has_many :tracks, :through => :municipalities
  
  attr_accessible :name, :code, :numeric_code
  
  def self.find_by_geolocation
    if @counties.blank?
      @counties = self.all.reject do |c|
        logger.info "County #{Geolocation.get_county}"
        Geolocation.translated(c.name) != Geolocation.get_county
      end
    end
    @counties.first
  end
  
end
