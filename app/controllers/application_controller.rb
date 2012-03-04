# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # include SslRequirement

  helper :all
  helper_method :current_user_session, :current_user
  # filter_parameter_logging :password, :password_confirmation

  before_filter :set_time_zone   
  before_filter :set_user_language

  before_filter :set_the_template   #unless DISPLAY_HAYPISTA_TEMPLATE
  layout 'zurb'                     unless DISPLAY_HAYPISTA_TEMPLATE


  # this probably needs to go in the helper
  def set_the_template(default_template='')
    the_action = self.action_name.singularize
    the_controller = self.class.to_s.gsub('Controller', '').downcase
    the_controller = 'user_sessions' if the_controller == 'usersessions'
    
    @the_template = "#{the_controller}/#{the_action}" if DISPLAY_HAYPISTA_TEMPLATE
    @the_template = "#{the_controller}/#{the_action}_zurb" unless DISPLAY_HAYPISTA_TEMPLATE
  
    unless (default_template.blank?)
      @the_template = default_template if DISPLAY_HAYPISTA_TEMPLATE
      @the_template = "#{default_template}_zurb" unless DISPLAY_HAYPISTA_TEMPLATE
    end
  
  end

  private  
  def set_user_language    
    I18n.locale = current_user.language if current_user 
  end

  def set_time_zone
    Time.zone = @current_user.time_zone if @current_user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find  # wrong number of arguments (0 for 1) w/ version 2.3.5
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      # flash[:notice] = I18n.t(:must_be_logged_in)
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      # flash[:notice] = I18n.t(:must_be_logged_out)
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def set_template
    set_the_template
  end

end
