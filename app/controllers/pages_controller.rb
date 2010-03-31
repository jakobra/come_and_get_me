class PagesController < ApplicationController
  filter_resource_access
  
  def index
    @pages = Page.all
  end
  
  def show
    # if params[:permalink]
    #   @page = Page.find_by_permalink(params[:permalink])
    #   raise ActiveRecord::RecordNotFound, "Page Not Found" if @page.nil?
    # else
    #   @page = Page.find(params[:id])
    # end
    
    if !@page.public and params[:permalink]
      raise ActiveRecord::RecordNotFound, "Page Not Found"
    end
    
    load_side_module("local_race_tracks")
  end
  
  def new
    #@page = Page.new
  end
  
  def create
    #@page = Page.new(params[:page])
    if params[:preview_button] or !@page.save
      render :action => 'new'
    else
      flash[:notice] = "Successfully created page."
      redirect_to @page
    end
  end
  
  def edit
    #@page = Page.find(params[:id])
  end
  
  def update
    #@page = Page.find(params[:id])
    if params[:preview_button] or !@page.update_attributes(params[:page])
      @page.attributes = params[:page]
      render :action => 'edit'
    else
      flash[:notice] = "Successfully updated page."
      redirect_to @page
    end
  end
  
  def destroy
    #@page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = "Successfully destroyed page."
    redirect_to pages_url
  end
  
  protected
  
  def load_page
    if params[:permalink]
      @page = Page.find_by_permalink(params[:permalink])
      raise ActiveRecord::RecordNotFound, "Page Not Found" if @page.nil?
    else
      @page = Page.find(params[:id])
    end
  end
end
