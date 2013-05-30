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
	end

	def create
		@company = Company.new(params[:company])
    @company.starts_at = Time.zone.now.change(:hour => 8, :min => 0, :sec => 0)
    @company.ends_at  = Time.zone.now.change(:hour => 23, :min => 0, :sec => 0)
	
		@user = current_user

		if @company.save and @company.create_company_details(current_user)
			successful_create
			
			@branch = Branch.new
			@branch.company_id = @company.id
			@branch.name = @company.name
			@branch.venue_id = @company.venue_id 
			@branch.service_id = @company.service_id
			@branch.play_id = @company.play_id
			@branch.starts_at = @company.starts_at
			@branch.ends_at = @company.ends_at
			@branch.url = @company.url
			@branch.save
			
			@branch.create_branch_details(current_user)
			
			# redirect_to :companies
			redirect_to	@company
			
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

