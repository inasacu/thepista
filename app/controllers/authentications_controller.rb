
class AuthenticationsController < ApplicationController
	before_filter :require_user, :only => [:destroy]
	before_filter :mobile_create, :only => [:create]
	before_filter :mobile_failure, :only => [:failure]

	def index
		@authentications = current_user.authentications if current_user
	end
  
  def mobile_create
    # gets origin param of the omniauth request
    omni_origin = request.env["omniauth.origin"]
    
    if omni_origin == "mobile"
      # remove cookies
      cookies.delete(:mobile_valid)
      cookies.delete(:user_data)
      
      # look for authentication based on oauth provider info
      omniauth = request.env["omniauth.auth"]
  		authentication = Authentication.find_from_omniauth(omniauth)
  		
  		if authentication
  		  #handle regular authentication - user was already registered
  		  mobile_token = Mobile::MobileToken.get_token(authentication.user.id, authentication.user.email, authentication.user.name)
  		  
  		  cookies[:mobile_valid] = {:value => MOBILE_LOGIN_REGISTERED}
  		  cookies[:user_data] = {:value => mobile_token.to_json}
  		else
  		  # if not present in authentications start sign up process
  		  signup_hash = Hash.new
  		  signup_hash = {:should_signup => true, :email_provided => omniauth['info']['email']}
  		  
  		  # Get token object with from info provided from oauth provider  
  		  mock_mobile_token = Mobile::MobileToken.get_mock_token(omniauth)
  		  
  		  # wrap the cookies info needed for sign up request from mobile app
  		  cookies[:mobile_valid] = {:value => MOBILE_LOGIN_SHOULD_SIGNUP}  
  		  cookies[:user_data] = {:value => mock_mobile_token.to_json}
  		  cookies[:signup_data] = {:value => signup_hash.to_json}
  		end
  		
  		render nothing: true
      return
    end
    
  end
  
  def mobile_failure
    # gets origin param of the omniauth request
    omni_origin = params[:origin]
        
    if omni_origin == "mobile"
  		  cookies[:mobile_valid] = {:value => MOBILE_LOGIN_FAILURE}
  		  cookies.delete(:user_data)
  		  render nothing: true
        return
    end
  end
  
	def create
		# render :text => request.env["omniauth.auth"].to_yaml
    
    # gets if the widget is the origin
    omni_origin = request.env["omniauth.origin"]
    
    # decides according to origin of the auth request
    if WidgetHelper.widget_is_origin(omni_origin)
      
      # info for logic actions
      isevent = session["widgetpista.isevent"]
      ismock = session["widgetpista.ismock"]
      event_id = session["widgetpista.eventid"]
      source_timetable_id = session["widgetpista.source_timetable_id"]
      event_starts_at = session["widgetpista.event_starts_at"]
      WidgetHelper.clean_session(session)
      
      # info for redirecting
      redirect_home = widget_home_url :from_omni_auth => 1
      redirect_signup = widget_check_omniauth_url :isevent => isevent, :ismock => ismock, :event => event_id, 
                                                  :source_timetable_id => source_timetable_id, 
                                                  :block_token => Base64::encode64(event_starts_at.to_i.to_s)
      
		else
		  
		  isevent = false
		  ismock = true
		  event_id = nil
		  source_timetable_id = nil
      event_timetable_pos = nil
		  
		  redirect_home = root_url
		  redirect_signup = provider_url
		  
		end
		    
		omniauth = request.env["omniauth.auth"]
		# successful_provider = "Successfully added #{omniauth['provider']} authentication"
		authentication = Authentication.find_from_omniauth(omniauth)
		
		if authentication
		  
      the_user = User.find(authentication.user)
      if the_user.confirmation_token.nil?
      else
        the_user.set_confirmation_token
        if the_user.save
          the_user.activation_send
          notice_activation_message
        end
        redirect_to root_url
        return
      end
		  
			# controller_welcome_provider(omniauth['provider'])
			UserSession.create(authentication.user, true) 
						
			# widget
			Schedule.takecareof_apuntate(authentication.user, isevent, ismock, event_id, source_timetable_id, event_starts_at)
			
			redirect_to redirect_home
			
		elsif current_user
			Authentication.create_from_omniauth(omniauth, current_user)
			controller_successful_provider
			
			redirect_to authentications_url			
			return
		
		else
			# find user based on email 
			@user_by_email = User.find_using_email((omniauth['info']['email']).downcase) if omniauth['info']['email']
			  
			if @user_by_email
				UserSession.create(@user_by_email)
				Authentication.create_from_omniauth(omniauth, @user_by_email)
				# controller_successful_provider(omniauth['provider'])
								
				# widget
  			Schedule.takecareof_apuntate(@user_by_email, isevent, ismock, event_id, source_timetable_id, event_starts_at)
			  
			  redirect_to redirect_home				
				return
			
			else				
				user = User.new				
				user.apply_omniauth(omniauth)
						
				if user.save
					UserSession.create(user)
					Authentication.create_from_omniauth(omniauth, user)
					# controller_successful_provider(omniauth['provider'])
					
					# widget
    			#Schedule.takecareof_apuntate(current_user, isevent, ismock, event_id, source_timetable_id, event_starts_at)
					
					redirect_to redirect_home
					return
					
				else
				  
					session[:omniauth] = omniauth.except('extra')
					redirect_to redirect_signup
					
					return
					
				end				
		
			end
		
		end
	end

	def failure
    # flash[:notice] = I18n.t(:verification_failed)
		redirect_to root_url
	end

	def blank
		render :text => "Not Found", :status => 404
	end

	def destroy
		@authentication = current_user.authentications.find(params[:id])
		flash[:notice] = "Successfully deleted #{@authentication.provider} authentication."
		@authentication.destroy
		# redirect_to edit_user_path(:current)
		redirect_to	user_url(current_user)
	end
end            