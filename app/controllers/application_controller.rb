# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  
  include AuthenticatedSystem
  
  SHALLOW_ACTIONS = ['edit', 'update', 'destroy']
  
  SPECIAL_AUTHORIZATION_CONTROLLERS = ['trainings', 'races']
  
  # Overrides access_denied in lib/authenticated_system.rb
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        flash[:error] = "Login required!"
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
  
  # Overrides authorized() in lib/authenticated_system.rb
  def authorized?(object = nil)
    if logged_in?
      if !object.eql? nil
       authorized_object?(object)
      elsif SPECIAL_AUTHORIZATION_CONTROLLERS.include?(controller_name)
        @authorize_controller_action ||= authorize_controller_action
      else
        true
      end
    else
      false
    end
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  
  def authorized_object?(object)
    if object.class.eql? current_user.class
      current_user == object ? true : false
    else
      user_resource = object.class.to_s.downcase.pluralize
      current_user.send(user_resource).include?(object) ? true : false
    end
  end
  
  def authorize_controller_action
    if SHALLOW_ACTIONS.include?(action_name)
      object = controller_name.singularize.classify.constantize.find(params[:id])
    else
      object = get_owner_object
    end
    authorized_object?(object)
  end
  
  def get_owner_object
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end
    
end