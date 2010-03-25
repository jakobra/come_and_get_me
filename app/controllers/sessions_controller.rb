# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  def new
    # render new.html.erb
  end

  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else
      password_authentication(params[:login], params[:password])
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = t("logout.logged_out")
    redirect_back_or_default('/')
  end

protected

  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
      case result.status
        when :missing
          failed_login t("login.open_id_missing")
        when :invalid
          failed_login t("login.open_id_invalid")
        when :canceled
          failed_login t("login.open_id_canceled")
        when :failed
          failed_login t("login.open_id_failed")
        when :successful
          successful_open_id_login(registration, identity_url)
      end
    end
  end
  
  def successful_open_id_login(registration, identity_url)
    user = User.find_or_initialize_by_identity_url(identity_url)
    if user.new_record?
      user.login = registration['nickname'] unless registration['nickname'].eql? ""
      user.email = registration['email'] unless registration['email'].eql? ""
      user.save(false)
      flash[:notice] = t("login.confirm_user_profile")
      redirect_to edit_user_path(user)
    else
      successful_login(user)
    end
  end
  
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
    handle_remember_cookie! new_cookie_flag
    flash[:notice] = t("login.logged_in")
    redirect_back_or_default('/')
  end
  
  def failed_login(msg = t("login.password_failure", :login => params[:login]))
    logger.info "Do we go here?"
    @login       = params[:login]
    @remember_me = params[:remember_me]
    if using_open_id?
      flash[:error] = msg
      redirect_to login_path
    else
      flash.now[:error] = msg
      render :action => :new
    end
  end
  
end
