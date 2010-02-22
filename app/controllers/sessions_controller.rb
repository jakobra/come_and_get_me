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
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected

  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration| 
      case result.status
        when :missing
          failed_login "Sorry, the OpenID server couldn't be found"
        when :invalid
          failed_login "Sorry, but this does not appear to be a valid OpenID"
        when :canceled
          failed_login "OpenID verification was canceled"
        when :failed
          failed_login "Sorry, the OpenID verification failed"
        when :successful
          successful_open_id_login(registration, identity_url)
      end
    end
  end
  
  def successful_open_id_login(registration, identity_url)
    user = User.find_or_initialize_by_identity_url(identity_url)
    logger.info "the registration email is ='#{registration['email']}'"
    logger.info "the registration nickname is ='#{registration['nickname']}'"
    logger.info "the registration full name is ='#{registration['fullname']}'"
    if user.new_record?
      unless registration['email'].blank?
        logger.info "registration email != blank "
        user.login = (registration['nickname'].eql? "") ? registration['email'] : registration['nickname']
        user.email = registration['email']
        user.save(false)
        successful_login(user)
      else
        failed_login "Sorry, your OpenId didn´t provide enough user info"
      end
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
    logger.info "Before"
    user.update_attributes(:last_login_at => Time.now, :last_login_ip => (request.remote_ip || "unknown" ))
    logger.info "After"
    self.current_user = user
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    redirect_back_or_default('/')
    flash[:notice] = "Logged in successfully"
  end
  
  def failed_login(msg = "Couldn't log you in as '#{params[:login]}'")
    @login       = params[:login]
    @remember_me = params[:remember_me]
    flash.now[:error] = msg
    render :action => 'new'
  end
  
end
