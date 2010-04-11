class SideModulesController < ApplicationController
  filter_resource_access
    
  def index
    @side_modules = SideModule.all
  end
  
  def show
    @side_module = SideModule.find(params[:id])
  end
  
  def new
    @side_module = SideModule.new
  end
  
  def create
    @side_module = SideModule.new(params[:side_module])
    if @side_module.save
      flash[:notice] = "Successfully created side module."
      redirect_to @side_module
    else
      render :action => 'new'
    end
  end
  
  def edit
    @side_module = SideModule.find(params[:id])
  end
  
  def update
    @side_module = SideModule.find(params[:id])
    if @side_module.update_attributes(params[:side_module])
      flash[:notice] = "Successfully updated side module."
      redirect_to @side_module
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @side_module = SideModule.find(params[:id])
    @side_module.destroy
    flash[:notice] = "Successfully destroyed side module."
    redirect_to side_modules_url
  end
end
