class UsersController < ApplicationController
	before_filter :require_no_user,     :only => [:signup, :create, :rpx_new, :rpx_create, :rpx_associate]
	before_filter :require_user,        :only => [:index, :list, :show, :notice, :edit, :update, :petition]  
	
	before_filter :get_default_user,		:only => [:show]   
	before_filter :get_sports,          :only => [:new, :edit, :signup, :rpx_new]
	before_filter :get_user_member,     :only => [:show, :notice] 
	before_filter :get_user_manager,    :only => [:set_available]
	before_filter :get_user_self,       :only => [:set_private_phone, :set_private_profile,  :set_teammate_notification, :set_message_notification, :set_last_minute_notification, :set_whatsapp]
	before_filter :get_user_group,      :only => [:set_manager, :remove_manager, :set_sub_manager, :remove_sub_manager, :set_subscription, :remove_subscription, :set_moderator, :remove_moderator]

	def index
		unless the_maximo
			redirect_to root_url 
			return
		end
		@users = User.where("users.archive = false and users.id != ?", current_user).page(params[:page])
		render @the_template
	end

	def list
		redirect_to root_url      
	end

	def show
		store_location

		if current_user == @user
			@authentications = current_user.authentications 
		end

		@client = ""
		@profile = ""
		@user_statistics = User.find_user_match_user_statistics(@user)

		all_users = []
		@user_statistics.each {|the_statistic| all_users << the_statistic.second_user_id unless all_users.include?(the_statistic.second_user_id)}
		@all_teammates = User.find(:all, :conditions => ["id in (?)", all_users])


		@user_hash_grid_statistics = []
		@user_hash_statistic  = {}
		the_statistic_user_id = 0
		counter_user_statistics = 0
		the_true_last_column = ""

		@user_statistics.each do |the_statistic| 

			the_true_column = "#{the_statistic.first_user_win}#{the_statistic.same_team}".upcase

			if (the_statistic_user_id != the_statistic.second_user_id.to_i)				
				@user_hash_grid_statistics << @user_hash_statistic if the_statistic_user_id > 0
				@user_hash_statistic = {}
				the_statistic_user_id = the_statistic.second_user_id.to_i

				@all_teammates.each {|teammate| @user_hash_statistic = {"user_id" => teammate}  if the_statistic.second_user_id.to_i == teammate.id.to_i}

				the_default_hash_values = {"TT" => "0", "TF" => "0", "FT" => "0", "FF" => "0"}
				@user_hash_statistic.merge!(the_default_hash_values)
				@user_hash_statistic.merge!({"#{the_true_column}" => the_statistic.total})

			else
				@user_hash_statistic.merge!({"#{the_true_column}" => the_statistic.total}) 

			end

		end

		@user_hash_grid_statistics << @user_hash_statistic	

		render @the_template    
	end

	def notice
		store_location
		set_the_template('users/show')
		render @the_template
	end

	def new
		if DISPLAY_HAYPISTA_SIGNUP
			return redirect_to :signup
		end 
		redirect_to root_url
	end

	def signup
		unless DISPLAY_HAYPISTA_SIGNUP
			redirect_to root_url 
			return
		end
		show_are_you_a_human
	end

	def edit
		if the_maximo
			@user = User.find(params[:id])
			return
		end 
		@user = current_user  
	end

	def create
		@user = User.new(params[:user])
		
		if session[:session_secret]
			unless has_are_you_a_human_passed   
				recaptcha_failure
				redirect_to root_url
				return
			end
		end

		@user.name = @user.email if @user.name.nil?
		@user.language = "es" if @user.language.nil?

		if session[:identifier]
			@user.identity_url = session[:identifier]
			@user.password = session[:identifier]
			@user.password_confirmation = session[:identifier]
		end

		if session[:omniauth]
			omniauth = session[:omniauth]
			@user.identity_url = omniauth['provider']
			@user.password = omniauth['provider']
			@user.password_confirmation = omniauth['provider']
		end
				
		if @user.save

			@user.email_to_name if @user.name.include?('@')
			@user.email_backup = @user.email
			@user.save

			Authentication.create_from_omniauth(session[:omniauth], @user) if session[:omniauth]
			
			if WidgetHelper.is_widget_form(params[:form_type])
			  
			  # info for logic actions
			  isevent = params[:isevent]
        ismock = params[:ismock]
        event_id =  params[:event]
        source_timetable_id =  params[:source_timetable_id]

        if params[:block_token]
          block_token = Base64::decode64(params[:block_token].to_s).to_i
          event_starts_at =  Time.zone.at(block_token)
        end
        
        #logic to add the user to a group and create event - this is when is a just signed up user
        Schedule.takecareof_apuntate(@user, isevent, ismock, event_id, source_timetable_id, event_starts_at)
        
        redirect_to widget_home_url  		  
  		  return
  		
  		end

		else
		  		  
		  if WidgetHelper.is_widget_form(params[:form_type])
		    redirect_to widget_check_omniauth_url :isevent => params[:isevent], :ismock => params[:ismock],
  		                                        :event => params[:event], :source_timetable_id => params[:source_timetable_id], 
                                              :block_token => params[:block_token]
  		  return
  		end
		  
			flash[:warning] = I18n.t(:password_email_conbination_issue)
			redirect_to :signup
			
			return
		
		end 

		session[:identifier] = nil if session[:identifier]
		session[:omniauth] = nil if session[:omniauth]

		successful_create
	
		redirect_to @user
	end

	def update
		@user = current_user

		if @user.update_attributes(params[:user]) 
			controller_successful_update
			redirect_to @user
		else
			render :action => 'edit'
		end		
	end

	def petition
		redirect_to root_url
		return
	end

	def set_language
		I18n.locale = "es"   
		I18n.locale = params[:id] if LANGUAGES.include?(params[:id])

		if current_user and LANGUAGES.include?(params[:id])
			@user = current_user
			@user.language = params[:id]
			@user.save!
			redirect_back_or_default('/')
			return
		end
		redirect_to login_url
	end

	def set_manager 
		unless current_user.is_creator_of?(@group)
			warning_unauthorized  
			return
		end
		@user.has_role!(:manager, @group)
		flash[:notice] = I18n.t(:manager_updated)
		redirect_back_or_default('/index')
	end

	def remove_manager 
		unless current_user.is_creator_of?(@group)
			warning_unauthorized  
			return
		end
		@user.has_no_role!(:manager, @group)
		flash[:notice] = I18n.t(:manager_updated)
		redirect_back_or_default('/index')
	end

	def set_sub_manager 
		unless is_current_manager_of(@group)
			warning_unauthorized  
			return
		end
		@user.has_role!(:sub_manager, @group)
		flash[:notice] = I18n.t(:sub_manager_updated)
		redirect_back_or_default('/index')
	end

	def remove_sub_manager 
		unless is_current_manager_of(@group)
			warning_unauthorized  
			return
		end
		@user.has_no_role!(:sub_manager, @group)
		flash[:notice] = I18n.t(:sub_manager_updated)
		redirect_back_or_default('/index')
	end

	def set_subscription 
		unless is_current_manager_of(@group)
			warning_unauthorized  
			return
		end
		@user.has_role!(:subscription, @group)
		Fee.set_season_player(@user, @group, true) if DISPLAY_FREMIUM_SERVICES

		flash[:notice] = I18n.t(:subscription_updated)
		redirect_back_or_default('/index')
	end 

	def remove_subscription 
		unless is_current_manager_of(@group)
			warning_unauthorized  
			return
		end
		@user.has_no_role!(:subscription, @group)
		Fee.set_season_player(@user, @group, false) if DISPLAY_FREMIUM_SERVICES

		flash[:notice] = I18n.t(:subscription_updated)
		redirect_back_or_default('/index')
	end

	def set_whatsapp
		if @user.update_attribute("whatsapp", !@user.whatsapp)
			@user.update_attribute("whatsapp", @user.whatsapp)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end

	def set_private_phone
		if @user.update_attribute("private_phone", !@user.private_phone)
			@user.update_attribute("private_phone", @user.private_phone)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end

	def set_private_profile
		if @user.update_attribute("private_profile", !@user.private_profile)
			@user.update_attribute("private_profile", @user.private_profile)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end

	def set_last_minute_notification
		if @user.update_attribute("last_minute_notification", !@user.last_minute_notification)
			@user.update_attribute("last_minute_notification", @user.last_minute_notification)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end

	def set_teammate_notification
		if @user.update_attribute("teammate_notification", !@user.teammate_notification)
			@user.update_attribute("teammate_notification", @user.teammate_notification)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end  

	def set_message_notification
		if @user.update_attribute("message_notification", !@user.message_notification)
			@user.update_attribute("message_notification", @user.message_notification)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end  

	def omniauth_new
		@user = User.new
		if session[:omniauth]
			@user.apply_omniauth(session[:omniauth])
			@user.valid?
		else
			redirect_to root_url
		end

	end

	def rpx_new
		if data = RPXNow.user_data(session[:rpx_token])

			session[:identifier] = data[:identifier]
			session[:name] = data[:name] || data[:displayName] || data[:nickName]
			session[:email] = data[:verifiedEmail] || data[:email]
			session[:login] = data[:verifiedEmail] || data[:email]

			@user = User.new
			@user.name = session[:name]
			@user.email = session[:email]
			@user.identity_url = session[:identifier]

			the_user = User.find_rpx_user(data[:identifier], @user.email)
			if the_user
				@email = existing_user.nil? ?   email : existing_user.email
				@user_session = UserSession.new(:email => @email)
				if @user_session.save
					redirect_to root_url
					return
				else
					redirect_to root_url
					return
				end
			end

		end
	end

	def rpx_create
		@user = User.new(params[:user])

		@user.identity_url = session[:identifier]
		@user.login = session[:login]
		@user.active = true
		@user.password = session[:identifier]
		@user.password_confirmation = session[:identifier]

		if @user.save
			UserMailer.send_email(@user).deliver

			# Won't be needing these anymore.
			session[:rpx_identifier] = nil
			session[:rpx_token] = nil
		else
			render :rpx_new 
			return
		end	

		redirect_to root_url
	end

	private
	# return if user is 
	def get_default_user
		@user = User.find(params[:id])
		if DEFAULT_GROUP_USERS.include?(@user.id)
			redirect_back_or_default('/index')
			return
		end
	end
	
	def get_user
		if params[:id] == 'current'
			@user = User.find(current_user) if current_user
		else
			@user = User.find(params[:id]) 
		end		
	end

	def get_user_manager
		get_user

		unless is_user_manager_of(@user)
			warning_unauthorized
			redirect_to root_url
			return
		end
	end

	def get_user_member
		get_user

		if @user.private_profile and DISPLAY_PRIVATE_PROFILE
			unless current_user.is_user_member_of?(@user)    
				warning_unauthorized
				redirect_to root_url
				return
			end
		end
	end

	def get_user_self
		get_user

		unless is_current_same_as(@user)
			warning_unauthorized
			redirect_to root_url
			return
		end
	end

	def get_user_group
		get_user
		@group = Group.find(params[:group])
	end

	def has_member_access
		get_user

		unless (current_user.is_user_member_of?(@user) || false) 
			redirect_to root_url
			return
		end
	end

	def get_sports
		@items = Sport.get_sport_name
	end

end