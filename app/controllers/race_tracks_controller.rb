class RaceTracksController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :records]
  
  def index
    if !params[:municipality_id].blank?
      @race_tracks = Municipality.find(params[:municipality_id]).race_tracks.paginate(:page => params[:page], :order => :title, :per_page => 25)
    elsif !params[:county_id].blank?
      @county = County.find(params[:county_id], :include => :municipalities)
      @municipalities = @county.municipalities
      @race_tracks = @county.race_tracks.paginate(:page => params[:page], :order => :title, :per_page => 25)
    else
      @race_tracks = RaceTrack.paginate(:page => params[:page], :order => :title, :per_page => 25)
    end
    @latest_race_tracks = RaceTrack.latest
  end

  def show
    @race_track = RaceTrack.find(params[:id])
    @tracks = @race_track.race_track_segments.map { |race_track_segment| race_track_segment.track.id }
  end

  def new
    @race_track = RaceTrack.new
    @race_track.race_track_segments.build
  end

  def edit
    @race_track = RaceTrack.find(params[:id])
  end

  def create
    @race_track = RaceTrack.new(params[:race_track])
    @race_track.created_by_user = current_user
    
    unless params[:race_track_segments].blank?
      params[:race_track_segments].each do |race_track_segment|
        @race_track.race_track_segments.build({:track_id => race_track_segment[:track_id], :quantity => race_track_segment[:quantity]})
      end
    end
    
    respond_to do |format|
      if @race_track.save
        flash[:notice] = t("race_tracks.create.created")
        format.html { redirect_to(@race_track) }
        format.xml  { render :xml => @race_track, :status => :created, :location => @race_track }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @race_track.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @race_track = RaceTrack.find(params[:id])
    @race_track.last_updated_by_user = current_user
    
    unless params[:race_track_segments].blank?
      race_track_segment_ids = params[:race_track_segments].map { |race_track_segment| race_track_segment[:id] }
      @race_track.race_track_segments.all(:conditions => ["id NOT IN (?)", race_track_segment_ids]).each { |race_track_segment| race_track_segment.destroy }
      
      @race_track_segments = []
      
      params[:race_track_segments].each do |race_track_segment|
        tmp_race_track_segment = RaceTrackSegment.find_or_initialize_by_id(race_track_segment[:id])
        if tmp_race_track_segment.new_record?
         @race_track_segments << @race_track.race_track_segments.build({:track_id => race_track_segment[:track_id], :quantity => race_track_segment[:quantity]})
        else
          tmp_race_track_segment.update_attributes({:track_id => race_track_segment[:track_id], :quantity => race_track_segment[:quantity]})
          @race_track_segments << tmp_race_track_segment
        end
      end
    end
    
    respond_to do |format|
      if @race_track.update_attributes(params[:race_track])
        if @race_track_segments.blank?
          flash[:notice] = t("race_tracks.update.updated")
          format.html { redirect_to(@race_track) }
          format.xml  { head :ok }
        else
          if @race_track_segments.all?(&:valid?)
            flash[:notice] = t("race_tracks.update.updated")
            format.html { redirect_to(@race_track) }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @race_track.errors, :status => :unprocessable_entity }
          end
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @race_track.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @race_track = RaceTrack.find(params[:id])
    @race_track.destroy
    
    respond_to do |format|
      format.html { redirect_to(race_tracks_url) }
      format.xml  { head :ok }
    end
  end
  
  def records
    @race_track = RaceTrack.find(params[:id])
  end
  
end
