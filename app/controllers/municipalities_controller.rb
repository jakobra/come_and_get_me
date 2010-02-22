class MunicipalitiesController < ApplicationController
  before_filter :admin_required, :except => [:index, :show]
  
  def index
    if params[:county_id].blank?
      @municipalities = Municipality.all(:include => :county)
    else
      @county = County.find(params[:county_id])
      @municipalities = @county.municipalities.find(:all, :include => :county)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.js  # index.js.rjs
    end
  end
  
  def show
    @municipality = Municipality.find(params[:id])
  end
  
  def new
    @municipality = Municipality.new
  end
  
  def create
    @municipality = Municipality.new(params[:municipality])
    if @municipality.save
      flash[:notice] = "Successfully created municipality."
      redirect_to @municipality
    else
      render :action => 'new'
    end
  end
  
  def edit
    @municipality = Municipality.find(params[:id])
  end
  
  def update
    @municipality = Municipality.find(params[:id])
    if @municipality.update_attributes(params[:municipality])
      flash[:notice] = "Successfully updated municipality."
      redirect_to @municipality
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @municipality = Municipality.find(params[:id])
    @municipality.destroy
    flash[:notice] = "Successfully destroyed municipality."
    redirect_to municipalities_url
  end
end
