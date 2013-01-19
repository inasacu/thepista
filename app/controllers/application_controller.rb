class ApplicationController < ActionController::Base
	helper :all
	protect_from_forgery

	helper_method :current_user, :current_user_session
	before_filter :set_time_zone , :set_user_language, :set_the_template  
	before_filter :set_browser_type #, :set_user_agent

	# layout 'zurb' 	unless DISPLAY_HAYPISTA_TEMPLATE

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

	# def set_user_agent
	# 	@user_agent = detect_user_agent
	# end
	
	def set_browser_type
		@browser_type = detect_browser
	end

	def the_maximo
		current_user.is_maximo? if current_user
	end

	def is_user_manager_of(item)
		current_user.is_user_manager_of?(item)
	end

	def is_current_same_as(item)
		current_user == item
	end	

	def is_current_manager_of(item)		
		current_user.is_manager_of?(item) or current_user.is_creator_of?(item)
	end

	def is_current_member_of(item)
		current_user.is_member_of?(item)
	end

	def notice_to_create_group
		flash[:notice] = I18n.t(:groups_howto_create)
	end

	def successful_create
		flash[:notice] = I18n.t(:successful_create)
	end

	def warning_unauthorized
		flash[:warning] = I18n.t(:unauthorized)
	end

	def recaptcha_failure
		flash[:warning] = I18n.t(:recaptcha_failure)
	end

	def controller_successful_create
		flash[:notice] = I18n.t(:invitation_successful_create)
	end

	def controller_successful_update
		flash[:success] = I18n.t(:successful_update)
	end
	
	def controller_successful_provider(omniauth)
		the_provider = "omniauth_provider_#{omniauth}"
		the_provider = I18n.t(the_provider)
		successful_provider = "Successfully added #{the_provider} authentication..."
		flash[:notice] = successful_provider
	end	

	def controller_welcome_provider(omniauth)
		the_provider = "omniauth_provider_#{omniauth}"
		the_provider = I18n.t(the_provider)
		successful_provider = "Welcome back #{the_provider} user..."
		flash[:notice] = successful_provider
	end

	def object_counter(objects)
		@counter = 0
		objects.each { |object|  @counter += 1 }
		return @counter
	end

  def sort_order(default)
    "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
  end

	protected
	def access_denied
		flash[:error] = "You do not have access!"
		redirect_to :controller => :user, :action => :new
	end

	def has_member_access(item)
		unless is_current_member_of(item)
			warning_unauthorized
			redirect_to root_url
			return
		end
	end

	def has_manager_access(item)
		unless is_current_manager_of(item)
			warning_unauthorized
			redirect_to root_url
			return
		end
	end

	private
	# def detect_user_agent
	# 	agent = request.headers["HTTP_USER_AGENT"].downcase
	# 	return agent
	# end
	
	def detect_browser
		if request.headers["HTTP_USER_AGENT"]
			agent = request.headers["HTTP_USER_AGENT"].downcase

			MOBILE_BROWSERS.each do |m|
				return "mobile" if agent.match(m)
			end
			return "desktop"
		else
			return "desktop"
		end
	end

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
		# redirect_to(session[:return_to] || default)
		redirect_to(session[:return_to] || root_url)
		session[:return_to] = nil
	end

	def set_template
		set_the_template
	end
end
