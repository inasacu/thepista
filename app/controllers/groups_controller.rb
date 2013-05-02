class GroupsController < ApplicationController
	before_filter :require_user    
	before_filter :get_venue, :only => [:set_subscription, :remove_subscription]
	before_filter :get_group, :only => [:team_list, :show, :edit, :update, :set_automatic_petition, :set_subscription, :remove_subscription]
	before_filter :has_manager_access, :only => [:edit, :update, :destroy, :set_automatic_petition]

	def index
		# @groups = Group.where("groups.archive = false").page(params[:page]).order('groups.created_at DESC')

		if Rails.env.development?
			@groups = Group.get_site_groups(params[:page]) 
		else
			@groups = Group.get_subplug_groups(params[:page])
		end
		render @the_template
	end

	def list
		redirect_to :action => 'index'
		return      
	end

	def team_list
		@users = @group.users
		@total = @group.users.count		
		@the_roster_infringe = nil
		@the_roster_infringe = @group.schedules.first.the_roster_infringe unless @group.schedules.empty?
		@scorecards = Scorecard.users_group_scorecard(@group, sort_order(''))  		
		render @the_template
	end

	def show
		store_location 
		render @the_template
	end

	def new      
		@group = Group.new
		@group.sport_id = 1
		@sports = Sport.find(:all)

		if params[:subplug_id]  
			@subplug = Subplug.find(params[:subplug_id])
			@group.item_id = @subplug.id
			@group.item_type = 'Subplug'
			@group.name = @subplug.name
		end

	end

	def create
		@group = Group.new(params[:group])	
		
		@group.name_to_second_team
		@group.default_conditions
		@group.sport_to_points_player_limit
		@group.time_zone = current_user.time_zone if !current_user.time_zone.nil?

		@user = current_user

		if @group.save and @group.create_group_details(current_user)
			successful_create
			
			if @group.item_type == 'Subplug'
					redirect_to enchufados_url
					return
			end
			
			redirect_to @group 
		else
			render :action => 'new'
		end
	end

	def edit
		set_the_template('groups/new')
	end

	def update
		@original_group = Group.find(params[:id])

		if @group.update_attributes(params[:group]) 
			if (@original_group.points_for_win != @group.points_for_win) or 
				(@original_group.points_for_lose != @group.points_for_lose) or 
				(@original_group.points_for_draw != @group.points_for_draw)

				Scorecard.delay.calculate_group_scorecard(@group)    
			end

			controller_successful_update
			redirect_to @group
		else
			render :action => 'edit'
		end
	end 

	def set_automatic_petition
		if @group.update_attribute("automatic_petition", !@group.automatic_petition)
			@group.update_attribute("automatic_petition", @group.automatic_petition)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end

	def set_subscription 
		unless is_current_manager_of(@venue)
			warning_unauthorized  
			return
		end
		@group.has_role!(:subscription, @venue)

		flash[:notice] = I18n.t(:subscription_updated)
		redirect_back_or_default('/index')
	end 

	def remove_subscription 
		unless is_current_manager_of(@venue)
			warning_unauthorized  
			return
		end
		@group.has_no_role!(:subscription, @venue)

		flash[:notice] = I18n.t(:subscription_updated)
		redirect_back_or_default('/index')
	end

	def set_automatic_petition
		if @group.update_attribute("automatic_petition", !@group.automatic_petition)
			@group.update_attribute("automatic_petition", @group.automatic_petition)  

			controller_successful_update
			redirect_back_or_default('/index')
		else
			render :action => 'index'
		end
	end

	private
	def get_group
		@group = Group.find(params[:id])
	end

	def get_venue
		@venue = Venue.find(params[:venue])
	end

	def has_manager_access
		unless is_current_manager_of(@group)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
	end
end