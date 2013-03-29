class TracksController < ApplicationController
  filter_resource_access :additional_collection => [:recent_track_records], :additional_member => [:file]
  include GpsCalculation
  
  def index
    @tracks = Track.all
    respond_to do |format|
      format.html {
        if !params[:municipality].blank?
          municipality = Municipality.find(params[:municipality])
          tracks = municipality.tracks.paginate(:page => params[:page], :order => :title, :per_page => 25)
          county = municipality.county
          municipalities = county.municipalities
        elsif !params[:county].blank?
          county = County.find(params[:county], :include => :municipalities)
          municipalities = county.municipalities
          tracks = county.tracks.paginate(:page => params[:page], :order => :title, :per_page => 25)
        else
          municipalities = Municipality.all
          tracks = Track.paginate(:page => params[:page], :order => :title, :per_page => 25)
        end
        @tracks_container = TracksContainer.new(tracks, county, municipality, municipalities, Track.latest)
      }
      format.js { render :json => @tracks, :only => [:id, :title, :distance] }
    end    
  end
  
  def show
    #@track = Track.find(params[:id])
    @track.revert_to(params[:version].to_i) if params[:version]
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @track }
    end
  end
  
  def new
    #@track = Track.new
    @track.tracksegments.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    #@track = Track.find(params[:id])
  end

  # POST /tracks
  # POST /tracks.xml
  def create
    #@track = Track.new(params[:track])
    
    if params[:track][:file].blank?
      params[:track][:tracksegments_attributes]["0"][:circle] = params[:track][:circle]
    else
      params[:track][:tracksegments_attributes]["0"][:points_attributes] = nil
    end
    
    @track = Track.new(params[:track])
    @track.created_by_user = current_user
    
    respond_to do |format|
      if @track.save
        flash[:notice] = t("tracks.create.created", :name => @track.title)
        format.html { redirect_to(@track) }
        format.xml  { render :xml => @track, :status => :created, :location => @track }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @track.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.xml
  def update
    #@track = Track.find(params[:id])
    attributes = params[:track]
    attributes[:updated_by] = current_user
    
    if attributes[:file].blank?
      attributes[:file] = nil
      unless attributes[:tracksegments_attributes]["0"][:points_attributes].blank?
        attributes[:tracksegments_attributes]["0"][:circle] = attributes[:circle]
        attributes["date(1i)"] = Date.today.year.to_s
        attributes["date(2i)"] = Date.today.month.to_s
        attributes["date(3i)"] = Date.today.day.to_s
        attributes["date(4i)"] = Time.now.hour.to_s
        attributes["date(5i)"] = Time.now.min.to_s
        attributes["date(6i)"] = Time.now.sec.to_s
      end
    else
      attributes[:file] = nil
      attributes[:tracksegments_attributes]["0"][:points_attributes] = nil
    end
    
    respond_to do |format|
      if @track.update_attributes(attributes)
        flash[:notice] = t("tracks.update.updated", :name => @track.title)
        format.html { redirect_to(@track) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @track.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.xml
  def destroy
    #@track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to(tracks_url) }
      format.xml  { head :ok }
    end
  end
  
  def records
    #@track = Track.find(params[:id])
    conditions = {}
    conditions["users.gender"] = params[:gender] if params[:gender] && params[:gender] != "-1"
    
    unless params[:event].blank?
      conditions["event_id"] = params[:event] 
      event = Event.find(params[:event])
    end
    
    races = @track.records(conditions)
    @track_records = TrackRecords.new(@track, event, races, params[:gender])
    recent_records(:all)
  end
  
  def recent_track_records
    recent_records(params[:gender].to_sym)
  end
  
  def file
    send_data @track.file.read, :type => @track.file_type
  end
end
