class PointsController < ApplicationController
  
  # GET /points
  # GET /points.xml
  def index
    @track = Track.find(params[:track_id])
    @track.revert_to(params[:version].to_i) if params[:version]
    
    respond_to do |format|
      format.xml  { render :xml => @track.points.find_with_sample_rate(params[:rate]) }
      format.gpx # index.gpx.builder
      format.kml # index.kml.builder
      format.js { render :json => @track.points.find_with_sample_rate(params[:rate]).to_json(:only => [:longitude, :latitude])}
    end
  end

end
