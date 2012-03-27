class ApplicationController < ActionController::Base
	helper :all
	protect_from_forgery
	
	helper_method :current_user, :current_user_session

	before_filter :set_time_zone , :set_user_language, :set_the_template   
	layout 'zurb' 	unless DISPLAY_HAYPISTA_TEMPLATE
	
	
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

	def the_maximo
		# the_maximo
		true
	end

	protected
	
	def access_denied
		flash[:error] = "You do not have access!"
		redirect_to :controller => :user, :action => :new
	end

	def has_member_access(item)
		unless current_user.is_member_of?(item)
			flash[:warning] = I18n.t(:unauthorized)
			redirect_to root_url
			return
		end
	end

	def has_manager_access(item)
		unless current_user.is_manager_of?(item)
			flash[:warning] = I18n.t(:unauthorized)
			redirect_to root_url
			return
		end
	end

	private
	def current_user_session
		return @current_user_session if defined?(@current_user_session)
		@current_user_session = UserSession.find
	end
	
	def current_user
		return @current_user if defined?(@current_user)
		@current_user = current_user_session && current_user_session.user
	end

	def set_user_language    
		I18n.locale = current_user.language if current_user 
	end

	def set_time_zone
		Time.zone = @current_user.time_zone if @current_user
	end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to user_url( :current )
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.url
  end

  def clear_location
    session[:return_to] = nil
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

	def set_template
		set_the_template
	end
end
