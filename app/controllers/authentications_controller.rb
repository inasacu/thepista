class AuthenticationsController < ApplicationController
	before_filter :require_user, :only => [:destroy]

	def index
		@authentications = current_user.authentications if current_user
	end

	def create
		# render :text => request.env["omniauth.auth"].to_yaml

		omniauth = request.env["omniauth.auth"]
		# successful_provider = "Successfully added #{omniauth['provider']} authentication"
		authentication = Authentication.find_from_omniauth(omniauth)
		
		if authentication
			# controller_welcome_provider(omniauth['provider'])
			UserSession.create(authentication.user, true) 
			redirect_to root_url
		
		
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
				redirect_back_or_default root_url
				return
			
			else				
				user = User.new				
				user.apply_omniauth(omniauth)
				
				if user.save
					UserSession.create(user)
					Authentication.create_from_omniauth(omniauth, user)
					# controller_successful_provider(omniauth['provider'])
					redirect_back_or_default root_url
					return
					
				else
					session[:omniauth] = omniauth.except('extra')
					redirect_to provider_url
					return
					
				end				
		
			end
		
		end
	end


	def failure
		flash[:notice] = I18n.t(:verification_failed)
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