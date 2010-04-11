# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :load_side_modules
  
  helper_method :admin?, :menu_roots
  
  include AuthenticatedSystem
  include SideModules
  
  # Overrides access_denied in lib/authenticated_system.rb
  def access_denied(msg = "Login required!")
    respond_to do |format|
      format.html do
        store_location
        flash[:error] = msg
        redirect_to new_session_path
      end
      # format.any doesn't work in rails version < http://dev.rubyonrails.org/changeset/8987
      # Add any other API formats here.  (Some browsers, notably IE6, send Accept: */* and trigger 
      # the 'format.any' block incorrectly. See http://bit.ly/ie6_borken or http://bit.ly/ie6_borken2
      # for a workaround.)
      format.any(:json, :xml) do
        request_http_basic_authentication 'Web Password'
      end
    end
  end
  
  def admin_required
    admin? || access_denied("Admin auhorization required!")
  end
  
  # Check if user has admin access
  def admin?
    if logged_in?
      current_user.admin? ? true : false
    end
  end
  
  def menu_roots
    MenuNode.roots(:order => :position, :conditions => {:viewable => true})
  end
  
  def load_side_modules
    MenuNode.all.each do |menu_node|
      if /^#{menu_node.side_module_regex}$/ =~ request.path
        logger.info request.path
        @current_menu_node = menu_node
        logger.info "True"
        logger.info @current_menu_node.url
        break
      end
    end
    @current_menu_node = MenuNode.find_by_url("default") if @current_menu_node.blank?
    
    @current_menu_node.menu_node_side_modules.left_before.each do |menu_node_side_module|
      if @content_for_left_side.blank?
        @content_for_left_side = render_html_content_to_string menu_node_side_module.side_module
      else
        @content_for_left_side += render_html_content_to_string menu_node_side_module.side_module
      end
    end
    @current_menu_node.menu_node_side_modules.right_before.each do |menu_node_side_module|
      if @content_for_right_side.blank?
        @content_for_right_side = render_html_content_to_string menu_node_side_module.side_module
      else
        @content_for_right_side += render_html_content_to_string menu_node_side_module.side_module
      end
    end
  end
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
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
  
  def render_html_content_to_string(item)
    unless item.style.blank?
      head_content = ["<style type=\"text/css\" media=\"screen\">", item.style, "</style>"]
      if @content_for_head.blank?
        @content_for_head = head_content.join
      else
        @content_for_head += head_content.join
      end
    end
    RedCloth.new(item.content).to_html
  end
    
end
