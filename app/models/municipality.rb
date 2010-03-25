class Municipality < ActiveRecord::Base
  belongs_to :county
  has_many :tracks
  has_many :race_tracks
  
  attr_accessible :name, :code, :county
  
  
  def self.find_by_geolocation(remote_ip)
    if @municipalities.blank? and Geoinformation.location(remote_ip)['CountryName'] == "Sweden"
      @municipalities = self.all.reject do |c|
        Geoinformation.translated(c.name) != Geoinformation.location(remote_ip)['City']
      end
    end
    @municipalities.blank? ? nil : @municipalities.first
  end
  
  def to_param
    "#{self.id}-#{CGI.escape(self.name)}"
  end
end
