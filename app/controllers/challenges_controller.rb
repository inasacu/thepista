class ChallengesController < ApplicationController
	before_filter :require_user    
	
	before_filter :get_challenge, :only => [:challenge_list, :edit, :update, :set_automatic_petition]
	before_filter :has_manager_access, :only => [:edit, :update, :set_automatic_petition, :set_challenge_subscription, :remove_challenge_subscription]
	before_filter	:get_user_challenge,	:only => [:set_challenge_subscription, :remove_challenge_subscription]

	before_filter :get_cup, :only =>[:new]
	# before_filter :has_member_access, :only => :show
	# before_filter :has_member_access, :only => [:challenge_list]

	def index
		redirect_to :cups
		return
	end

	def list
		redirect_to :cups
		return
	end

	def challenge_list
		@users = @challenge.users.page(params[:page])
		@total = @challenge.users.count   
		@casts = @challenge.casts.page(params[:page]).joins("LEFT JOIN users on users.id = casts.user_id").order("casts.game_id, users.name")
		set_the_template('casts/index')
		render @the_template
	end

	def show
		store_location    
		@challenge = Challenge.find(params[:id])
		render @the_template
	end

	def new
		@challenge = Challenge.new
		@challenge.time_zone = current_user.time_zone if !current_user.time_zone.nil?

		if @cup
			@challenge.cup_id = @cup.id 
			@challenge.description = @cup.description
			@challenge.conditions = @cup.conditions
			@challenge.starts_at = @cup.starts_at
			@challenge.ends_at = @cup.ends_at
			@challenge.reminder_at = @cup.starts_at - 7.days     
		end   
		render @the_template
	end

	def create
		@challenge = Challenge.new(params[:challenge])	

		@cup = Cup.find(@challenge.cup_id)	
		@challenge.starts_at = @cup.starts_at
		@challenge.ends_at = @cup.ends_at
		@challenge.reminder_at = @cup.starts_at - 7.days
		@challenge.player_limit = 99

		if @challenge.save and @challenge.create_challenge_details(current_user)
			successful_create
			redirect_to @challenge
		else
			render :action => 'new'
		end
	end 

	def set_automatic_petition
		if @challenge.update_attribute("automatic_petition", !@challenge.automatic_petition)
			@challenge.update_attribute("automatic_petition", @challenge.automatic_petition)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end

	def set_challenge_subscription 
		unless is_current_manager_of(@challenge)
			warning_unauthorized  
			return
		end
		@user.has_role!(:subscription, @challenge)

		flash[:notice] = I18n.t(:subscription_updated)
		redirect_back_or_default('/index')
	end 

	def remove_challenge_subscription 
		unless is_current_manager_of(@challenge)
			warning_unauthorized  
			return
		end
		@user.has_no_role!(:subscription, @challenge)

		flash[:notice] = I18n.t(:subscription_updated)
		redirect_back_or_default('/index')
	end
	
	def edit
		set_the_template('challenges/new')
		render @the_template
	end

	def update
		@original_challenge = Challenge.find(params[:id])

		if @challenge.update_attributes(params[:challenge]) 
			controller_successful_update
			redirect_to @challenge
		else
			render :action => 'edit'
		end
	end 

	private
	def get_challenge
		@challenge = Challenge.find(params[:id]) 
	end

	def get_cup
		@cup = Cup.find(params[:cup_id])
	end
	
	def get_user_challenge
		@user = User.find(params[:id]) 		
		@challenge = Challenge.find(params[:challenge])
	end

	def has_member_access
		if is_current_member_of(@challenge) or the_maximo
			warning_unauthorized
			redirect_to root_url
			return
		end
	end

	def has_manager_access
	    if is_current_manager_of(@challenge) or the_maximo
	    else
			warning_unauthorized
			redirect_to root_url
			return
		end
	end
end