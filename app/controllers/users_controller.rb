class UsersController < ApplicationController
  filter_resource_access :additional_member => [:statistics, :records, :track_statistics, :track_statistics_data, :events]
  
  def index
    @users = User.all
    load_side_module("last_races")
    Rails.logger.info @last_races.count
  end
  
  def show
    #@user = User.find_by_login(params[:id])
    @pbs = @user.races.personal_bests
  end
  
  def new
    @user = User.new
    load_side_module("local_tracks")
    recent_records(:all)
  end
  
  def edit
    #@user = User.find_by_login(params[:id])
  end
 
  def create
    logout_keeping_session!
    #@user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = t("users.create.created")
    else
      recent_records(:all)
      render :action => 'new'
    end
  end
  
  def update
    #@user = User.find_by_login(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(user_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    #@user = User.find_by_login(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def admin
    #@user = User.find(params[:id])
    @user.toggle!(:admin)

    redirect_to(users_url)
  end
  
  def statistics
    #@user = User.find(params[:id])
    @start_date = Date.civil(params[:from][:year].to_i, params[:from][:month].to_i, params[:from][:day].to_i)
    @end_date = Date.civil(params[:to][:year].to_i, params[:to][:month].to_i, params[:to][:day].to_i)
  end
  
  def records
    #@user = User.find(params[:id])
    @records = @user.races.records
  end
  
  def track_statistics
    begin
      races = @user.races.find_all_by_track_id(params[:track_id], :order => params[:order])
    rescue
      races = @user.races.find_all_by_track_id(params[:track_id])
    end
    
    chart_races = races.reject { |r| (r.hr_avg.blank? || r.hr_max.blank?) }
    count = chart_races.count
    chart_races = (chart_races.count > 20) ? chart_races.slice(-21, 20) : chart_races
    
    @track_statistics = TrackStatistics.new(races, chart_races, count, Track.find(params[:track_id]))
  end
  
  def track_statistics_data
    @races = @user.races.find(:all, :conditions => ["track_id = ? AND hr_max IS NOT NULL AND hr_avg IS NOT NULL", params[:track_id]])
    @races = @races[params[:from].to_i..params[:to].to_i]
  end
  
  def events
    #@user = User.find(params[:id])
  end
  
  protected
  
  def load_user
    if params[:login]
      @user = User.find_by_login(params[:login])
    else
      @user = User.find_by_login(params[:id])
    end
  end
end
