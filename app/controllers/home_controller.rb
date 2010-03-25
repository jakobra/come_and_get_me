class HomeController < ApplicationController
  
  def index
    @area = County.find_by_geolocation(request.remote_ip)
    @area = @area.municipalities.find_by_geolocation(request.remote_ip) unless @area.blank?
    @race_tracks = @area.blank? ? nil : @area.race_tracks
    
    @last_race = Race.find(:last)
    @recent_records = Race.recent_records
  end
  
end
