# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  def new
    load_side_module("local_tracks")
  end

  def create
    password_authentication(params[:login], params[:password])
  end

  def destroy
    logout_killing_session!
    flash[:notice] = t("logout.logged_out")
    redirect_back_or_default('/')
  end

private
  
  def password_authentication(login, password)
    logout_keeping_session!
    user = User.authenticate(login, password)
    if user
      successful_login(user)
    else
      failed_login
    end
  end
  
  def successful_login(user)
    user.update_attributes(:last_login_at => Time.now, :last_login_ip => (request.remote_ip || "unknown" ))
    self.current_user = user
    new_cookie_flag = (params[:remember_me] == "1")
    #TODO
    #handle_remember_cookie! new_cookie_flag
    flash[:notice] = t("login.logged_in")
    redirect_back_or_default(user_path(self.current_user))
  end
  
  def failed_login(msg = t("login.password_failure", :login => params[:login]))
    @login = params[:login]
    @remember_me = params[:remember_me]
    load_side_module("local_tracks")
    flash.now[:error] = msg
    render :action => :new
  end
  
end
