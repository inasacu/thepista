class AuthenticationsController < ApplicationController
	before_filter :require_user, :only => [:destroy]

	def index
		@authentications = current_user.authentications if current_user
	end

	def create
		# render :text => request.env["omniauth.auth"].to_yaml
    
    # gets if the widget is the origin
    omniOrigin = request.env["omniauth.origin"]
    
    # decides according to origin of the auth request
    if WidgetHelper.widget_is_origin(omniOrigin)
      
      # info for logic actions
      isevent = request.env["widget.isevent"]
      ismock = request.env["widget.ismock"]
      eventid = request.env["widget.event"]
      
      # info for redirecting
      redirect_home = widget_home_url
      redirect_signup = widget_check_omniauth_url
      
		else
		  
		  isevent = false
		  ismock = false
		  eventid = 0
		  
		  redirect_home = root_url
		  redirect_signup = provider_url
		end
    
		omniauth = request.env["omniauth.auth"]
		# successful_provider = "Successfully added #{omniauth['provider']} authentication"
		authentication = Authentication.find_from_omniauth(omniauth)
		
		if authentication
			# controller_welcome_provider(omniauth['provider'])
			UserSession.create(authentication.user, true) 
			
			# widget
			Schedule.takecareof_apuntate(current_user, isevent, ismock, eventid)
			
			redirect_to redirect_home
			
		elsif current_user
			Authentication.create_from_omniauth(omniauth, current_user)
			controller_successful_provider
			
			# widget
			Schedule.takecareof_apuntate(current_user, isevent, ismock, eventid)
			
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
  			Schedule.takecareof_apuntate(current_user, isevent, ismock, eventid)
				
				redirect_to redirect_home
				
				#redirect_back_or_default root_url
				return
			
			else				
				user = User.new				
				user.apply_omniauth(omniauth)
						
				if user.save
					UserSession.create(user)
					Authentication.create_from_omniauth(omniauth, user)
					# controller_successful_provider(omniauth['provider'])
					
					# widget
    			Schedule.takecareof_apuntate(current_user, isevent, ismock, eventid)
					
					redirect_to redirect_home
					
					#redirect_back_or_default root_url
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
		flash[:notice] = "Sorry, You din't authorize"
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