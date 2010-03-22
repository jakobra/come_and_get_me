class HomeController < ApplicationController
  
  def index
    @area = Geolocation.find_closest_area(request.remote_ip)
    @race_tracks = RaceTrack.find_by_geolocation(request.remote_ip)
    
    @last_race = Race.find(:last)
    @recent_records = Race.recent_records
  end
  
end
