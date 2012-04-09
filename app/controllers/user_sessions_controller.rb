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
		if data = RPXNow.user_data(params[:token])
			data = {:name => data[:username], :email => data[:email], :identifier => data[:identifier]}
			the_user = User.find_by_email(data[:email]) 

			if the_user.nil?
				# Need to "sign up", store the token so we can get the data again later...
				session[:rpx_token] = params[:token]
				redirect_to :rpx_signup
				return
			end
			@user_session = UserSession.new(the_user)
			if @user_session.save
				redirect_to root_url
			else
				redirect_to root_url
			end
		end
	end

	def destroy
		@user_session = current_user_session
		@user_session.destroy if @user_session
		redirect_to root_url
	end

end
