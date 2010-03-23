class PagesController < ApplicationController
  filter_resource_access
  
  def index
    @pages = Page.all
  end
  
  def show
    if params[:permalink]
      @page = Page.find_by_permalink(params[:permalink])
      raise ActiveRecord::RecordNotFound, "Page Not Found" if @page.nil?
    else
      @page = Page.find(params[:id])
    end
  end
  
  def new
    #@page = Page.new
  end
  
  def create
    #@page = Page.new(params[:page])
    if @page.save
      flash[:notice] = "Successfully created page."
      redirect_to @page
    else
      render :action => 'new'
    end
  end
  
  def edit
    #@page = Page.find(params[:id])
  end
  
  def update
    #@page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:notice] = "Successfully updated page."
      redirect_to @page
    else
      render :action => 'edit'
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