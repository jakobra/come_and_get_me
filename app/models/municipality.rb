class Municipality < ActiveRecord::Base
  belongs_to :county
  has_many :tracks
  has_many :race_tracks
  
  attr_accessible :name, :code, :county
  
  def self.find_by_geolocation
    if @municipalities.blank?
      @municipalities = self.all.reject do |c|
        Geolocation.translated(c.name) != Geolocation.get_city
      end
    end
    @municipalities.first
  end
end
