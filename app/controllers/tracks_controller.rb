class TracksController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  include GpsCalculation
  
  # GET /tracks
  # GET /tracks.xml
  def index
    if !params[:municipality_id].blank?
      @tracks = Municipality.find(params[:municipality_id]).tracks.paginate(:page => params[:page], :order => :title, :per_page => 25)
    elsif !params[:county_id].blank?
      @county = County.find(params[:county_id], :include => :municipalities)
      @municipalities = @county.municipalities
      @tracks = @county.tracks.paginate(:page => params[:page], :order => :title, :per_page => 25)
    else
      @tracks = Track.paginate(:page => params[:page], :order => :title, :per_page => 25)
    end
    @latest_tracks = Track.latest
  end

  # GET /tracks/1
  # GET /tracks/1.xml
  def show
    @track = Track.find(params[:id])
    @track.revert_to(params[:version].to_i) if params[:version]
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @track }
    end
  end

  # GET /tracks/new
  # GET /tracks/new.xml
  def new
    @track = Track.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
  end

  # POST /tracks
  # POST /tracks.xml
  def create
    @track = Track.new(params[:track])
    @track.created_by_user = current_user
    
    if !params[:points].blank? and params[:track][:track].blank?
      create_tracksegment_from_plot(params[:points], params[:track][:circle])
    end
    
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
    @track = Track.find(params[:id])
    
    if !params[:points].blank? and params[:track][:track].blank?
      tracksegment = create_tracksegment_from_plot(params[:points], params[:track][:circle])
      tracksegment.save
      @track.date = Time.now
    end
    
    respond_to do |format|
      if @track.update_attributes({:updated_by => current_user}.merge(params[:track]))
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
    @track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to(tracks_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def create_tracksegment_from_plot(points, circle)
    version = @track.new_record? ? 1 : @track.version + 1
    tracksegment = @track.tracksegments.build({:track_version => version, :circle => circle})
    points.each do |point| 
      tracksegment.points.build(:latitude => point[:lat], :longitude => point[:lng], :elevation => point[:ele]) if point_valid?(point)
    end
    @track.track_file_name = nil
    @track.track_content_type = nil
    @track.track_file_size = nil
    tracksegment
  end
  
  def point_valid?(point)
    (point[:lat].blank? or point[:lng].blank?) ? false : true
  end
end
