class Municipality < ActiveRecord::Base
  belongs_to :county
  has_many :tracks
  has_many :race_tracks
  
  attr_accessible :name, :code, :county
  
  def self.find_by_geolocation(remote_ip)
    if @municipalities.blank?
      @municipalities = self.all.reject do |c|
        Geolocation.translated(c.name) != Geolocation.get_city(remote_ip)
      end
    end
    @municipalities.first
  end
  
  def to_param
    "#{self.id}-#{CGI.escape(self.name)}"
  end
end
