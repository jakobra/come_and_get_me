class TracksController < ApplicationController
  filter_resource_access :additional_collection => [:recent_track_records]
  include GpsCalculation
  
  # GET /tracks
  # GET /tracks.xml
  def index
    if !params[:municipality].blank?
      @municipality = Municipality.find(params[:municipality])
      @tracks = @municipality.tracks.paginate(:page => params[:page], :order => :title, :per_page => 25)
      @county = @municipality.county
      @municipalities = @county.municipalities
    elsif !params[:county].blank?
      @county = County.find(params[:county], :include => :municipalities)
      @municipalities = @county.municipalities
      @tracks = @county.tracks.paginate(:page => params[:page], :order => :title, :per_page => 25)
    else
      @municipalities = Municipality.all
      @tracks = Track.paginate(:page => params[:page], :order => :title, :per_page => 25)
    end
    @latest_tracks = Track.latest
  end

  # GET /tracks/1
  # GET /tracks/1.xml
  def show
    #@track = Track.find(params[:id])
    @track.revert_to(params[:version].to_i) if params[:version]
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @track }
    end
  end

  # GET /tracks/new
  # GET /tracks/new.xml
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
    
    unless params[:track][:track].blank?
      params[:track][:tracksegments_attributes]["0"][:points_attributes] = nil
      params[:track][:tracksegments_attributes]["0"][:circle] = params[:track][:circle] unless params[:track][:tracksegments_attributes]["0"][:points_attributes].blank?
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
    
    if attributes[:track].blank?
      unless attributes[:tracksegments_attributes]["0"][:points_attributes].blank?
        attributes[:track] = nil
        attributes[:tracksegments_attributes]["0"][:circle] = attributes[:circle]
        attributes["date(1i)"] = Date.today.year.to_s
        attributes["date(2i)"] = Date.today.month.to_s
        attributes["date(3i)"] = Date.today.day.to_s
        attributes["date(4i)"] = Time.now.hour.to_s
        attributes["date(5i)"] = Time.now.min.to_s
        attributes["date(6i)"] = Time.now.sec.to_s
      end
    else
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
    conditions["users.gender"] = params[:gender] if params[:gender]
    conditions["event_id"] = params[:event_id] unless params[:event_id].blank?
    recent_records(:all)
  end
  
  def recent_track_records
    recent_records(params[:gender].to_sym)
  end
  
end
