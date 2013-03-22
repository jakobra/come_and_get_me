class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  
  before_filter :load_side_modules
  
  helper_method :menu_roots
  
  include AuthenticatedSystem
  include SideModules
  
  def menu_roots
    MenuNode.roots(:order => :position, :conditions => {:viewable => true})
  end
  
  def load_side_modules
    @current_menu_node = MenuNodeResolver.new(request).current_menu_node
    side_module_resolver = SideModuleResolver.new(@current_menu_node)
    @content_for_left_side = side_module_resolver.left_side
    @content_for_right_side = side_module_resolver.right_side
    @content_for_head = side_module_resolver.head
  end
  
  private
  
  def load_side_module(side_module)
    send(side_module)
  end
  
  protected
  
  def permission_denied
    if current_user
      flash[:error] = t("common.admin_required")
      redirect_to root_path
    else
      flash[:error] = t("common.login_required")
      redirect_to new_session_path
    end
  end
end
