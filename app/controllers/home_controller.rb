class HomeController < ApplicationController
  
  def index
    load_side_module("local_race_tracks")
    
    load_side_module("last_race")
    
    load_side_module("recent_records")
  end
  
end
