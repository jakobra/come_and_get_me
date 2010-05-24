class HomeController < ApplicationController
  
  def index
    load_side_module("local_tracks")
    
    load_side_module("last_races")
    
    recent_records(:all)
    @index_page = Page.find_by_permalink("index")
  end
  
  def local_area
    if !params[:municipality_id].blank?
      @area = Municipality.find(params[:municipality_id])
    elsif !params[:county_id].blank?
      @area = County.find(params[:county_id])
    end
  end
  
end
