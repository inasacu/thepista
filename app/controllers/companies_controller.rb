class CompaniesController < ApplicationController
	before_filter :require_user
	
	before_filter :get_company, :only => [:show, :edit, :update]

	def index
		@companies = Company.get_site_companies(params[:page]) 
	end
	
	def show
		@companies = Company.where(["id = ?", @company])
	end

	def new
		@company = Company.new
		@group = Group.new
		@timetable = Timetable.new
		
		@company.url = "http://"
		@group.sport_id = 1
	end

	def create
		@company = Company.new(params[:company])
		@company.starts_at = Time.zone.now.change(:hour => 8, :min => 0, :sec => 0)
		@company.ends_at  = Time.zone.now.change(:hour => 23, :min => 0, :sec => 0)
		@company.venue_id = 999
		@company.description = I18n.t(:description)

		@user = current_user

		if @company.save and @company.create_company_details(current_user)
			# successful_create

			@branch = Branch.new
			@branch.company_id = @company.id
			@branch.name = @company.name
			@branch.venue_id = @company.venue_id 
			@branch.service_id = @company.service_id
			@branch.play_id = @company.play_id
			@branch.starts_at = @company.starts_at
			@branch.ends_at = @company.ends_at
			@branch.url = @company.url

			if @branch.save and @branch.create_branch_details(current_user)

				@group = Group.new(params[:group])
				@group.item = @branch
				@group.name = @branch.name if @group.name.nil? 
				@group.name_to_second_team
				@group.default_conditions
				@group.sport_to_points_player_limit
				@group.time_zone = current_user.time_zone if !current_user.time_zone.nil?

				@user = current_user

				if @group.save and @group.create_group_roles(current_user)
					successful_create
				end

			end

			redirect_to	@group

		else
			render :action => 'new'
		end
	end

	def edit
		set_the_template('companies/new')
	end

	def update
		@original_company = Company.find(params[:id])

		if @company.update_attributes(params[:company]) 
			controller_successful_update
			redirect_to @company
		else
			render :action => 'edit'
		end
	end

	private
	def get_company
		@company = Company.find(params[:id])
	end

end

