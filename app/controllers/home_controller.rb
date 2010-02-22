class HomeController < ApplicationController
  
  def index
    @area = Geolocation.find_closest_area
    @race_tracks = RaceTrack.find_by_geolocation
    
    @last_comment = Comment.find(:last)
    @last_race = Race.find(:last)
  end
  
end
