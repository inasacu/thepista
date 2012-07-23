class UserSessionsController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create]

	def index
		# this is where RPX will return to if the user cancelled the login process
		redirect_to current_user ? root_url : new_user_session_url
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user_session = UserSession.new
	end

	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			redirect_to root_url
		else
			render :action => :new
		end
	end

	def rpx_create
		data = RPXNow.user_data(params[:token], :extended => 'true')

		if data.blank?
			@user_session = UserSession.new
			respond_to do |format|
				format.html { render :action => :new }
			end
		else

			# Authentication good... check if need to "sign up"... if user email is listed, then simply login and disrecard mapping id to rpxnow...
			email = data[:verifiedEmail] || data[:email]
			@user = User.find_by_email(email)

			openid_identifier = data[:identifier]
			@user_openid = User.find_by_identity_url(openid_identifier)

			if @user

				if LANGUAGES.include?(I18n.locale)
					@user.language = I18n.locale 
					@user.save!
				end

				UserSession.create(@user)
				redirect_back_or_default root_url
				return

			elsif @user_openid
				UserSession.create(@user_openid)
				redirect_back_or_default root_url 
				return

			else

				# Authentication good.. check if need to "sign up"...if user has no key assigned in rpxnow add it
				primary_key = data[:id]
				unless primary_key
					# Need to "sign up", store the token so we can get the data again later...
					session[:rpx_token] = params[:token]
					redirect_to rpx_signup_path
					return 
					
				else
					# This OpenID has already "signed up" and been associated to a local user. They are already
					# authenticated so just create their session for them.
					@user = User.find(primary_key)
					if @user
						UserSession.create(@user)
						redirect_back_or_default root_url		
						return
						
					else
						flash[:error] = "Unable to find the user that your third-party account maps to. Please contact support@haypista.com for help."
						respond_to do |format|
							format.html { render :action => :new }
						end
					end
				end

			end

		end

		# this code has been set to prevent failure when user goes to myopenid and selects cancel
	rescue RPXNow::ApiError
		redirect_to root_url

	end


	def destroy
		@user_session = current_user_session
		@user_session.destroy if @user_session
		redirect_to root_url
	end

end
