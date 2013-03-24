class TrainingsController < ApplicationController
  filter_resource_access :nested_in => :users
  
  def index
    #@user = User.find_by_login(params[:user_id])
    @trainings = @user.trainings.paginate(:page => params[:page], :order => "date DESC", :per_page => 25)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trainings }
    end
  end
  
  def show
    #@training = Training.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @training }
    end
  end
  
  def new
    #@user = User.find_by_login(params[:user_id])
    @training = @user.trainings.build
    @training.build_note
    @training.races.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @training }
    end
  end
  
  def edit
    #@training = Training.find(params[:id])
  end
  
  def create
    #@user = User.find_by_login(params[:user_id])
    @training = @user.trainings.build(params[:training])

    respond_to do |format|
      if @training.save
        flash[:notice] = t("trainings.create.created", :date => @training.date)
        format.html { redirect_to(@training) }
        format.xml  { render :xml => @training, :status => :created, :location => @training }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @training.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    #@training = Training.find(params[:id])

    respond_to do |format|
      if @training.update_attributes(params[:training])
        flash[:notice] = t("trainings.update.updated", :date => @training.date)
        format.html { redirect_to(@training) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @training.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    #@training = Training.find(params[:id])
    @training.destroy

    respond_to do |format|
      format.html { redirect_to(user_trainings_url(@training.user)) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def load_user
    @user = User.find_by_login(params[:user_id])
  end
end
