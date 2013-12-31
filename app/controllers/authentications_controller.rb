
class AuthenticationsController < ApplicationController
	before_filter :require_user, :only => [:destroy]

	def index
		@authentications = current_user.authentications if current_user
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
						
      cookies[:secureusertokens] = { :value => Base64::encode64("#{the_user.email}#{the_user.id}#{Time.zone.now}"), :expires => 2.weeks.from_now }
			# cookies.delete(:secureusertokens)
			
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
          # cookies.delete(:secureusertokens)
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