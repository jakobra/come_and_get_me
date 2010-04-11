class MenuNodesController < ApplicationController
  filter_resource_access
  
  def index
    @menu_nodes = MenuNode.roots
  end
  
  def show
    @menu_node = MenuNode.find(params[:id])
  end
  
  def new
    @menu_node = MenuNode.new
  end
  
  def create
    @menu_node = MenuNode.new(params[:menu_node])
    if @menu_node.save
      flash[:notice] = "Successfully created menu node."
      redirect_to @menu_node
    else
      render :action => 'new'
    end
  end
  
  def edit
    @menu_node = MenuNode.find(params[:id])
  end
  
  def update
    @menu_node = MenuNode.find(params[:id])
    if @menu_node.update_attributes(params[:menu_node])
      flash[:notice] = "Successfully updated menu node."
      redirect_to @menu_node
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @menu_node = MenuNode.find(params[:id])
    @menu_node.destroy
    flash[:notice] = "Successfully destroyed menu node."
    redirect_to menu_nodes_url
  end
end
