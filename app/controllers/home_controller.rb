class HomeController < ApplicationController
  
  def index
    load_side_module("local_tracks")
    
    load_side_module("last_race")
    
    load_side_module("recent_records")
    @index_page = Page.find_by_permalink("index")
  end
  
end
