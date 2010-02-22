class UsersController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :new, :create, :statistics]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id], :include => :races)
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])

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
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  # PUT /users/1/admin
  def admin
    @user = User.find(params[:id])
    @user.toggle!(:admin)

    redirect_to(users_url)
  end
  
  # GET /users/1/statistics
  # GET /users/1/statistics.xml
  def statistics
     @user = User.find(params[:id])
     @start_date = Date.civil(params[:from][:year].to_i, params[:from][:month].to_i, params[:from][:day].to_i)
     @end_date = Date.civil(params[:to][:year].to_i, params[:to][:month].to_i, params[:to][:day].to_i)
     
     respond_to do |format|
       format.html
       format.xml  { head :ok }
       format.js
    end
  end
end
