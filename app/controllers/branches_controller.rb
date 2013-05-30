class BranchesController < ApplicationController
	before_filter :require_user

	before_filter		:get_group,								:only => [:show]
	before_filter   :get_company,    					:only => [:new]
	before_filter		:get_branch,							:only => [:edit, :update]
	before_filter   :has_manager_access,  		:only => [:new, :create, :edit, :update]

	def index  
		redirect_to company_url   
	end

	def show
		store_location
		if params[:block_token]
			block_token = Base64::decode64(params[:block_token].to_s).to_i
			@current_user_zone = Time.zone.at(block_token)
		else
			@current_user_zone = Time.zone.now
		end

		render @the_template  
	end

	def new
		@branch = Branch.new

		if @company
			@branch.company_id = @company.id
		else 
			redirect_to root_url
		end

	end

	def create
		@branch = Branch.new(params[:branch]) 
		@company = Company.find(@branch.company_id)

		if @branch.save and @branch.create_branch_details(current_user)
			successful_create

			successful_create
			redirect_to @company
		else
			render :action => 'new'
		end
	end

	def edit
		set_the_template('branches/new')
		render @the_template
	end

	def update
		if @branch.update_attributes(params[:branch])  
			controller_successful_update
			redirect_to @company
		else
			render :action => 'edit'
		end
	end

	private
	def get_group
		@group = Group.find(params[:id])
		@branch = @group.item
		@company = @branch.company
	end
	
	def get_branch
		@branch = Branch.find(params[:id])
		@company = @branch.company
	end	

	def get_company
		@company = Company.find(params[:company_id])
	end

	def has_manager_access
		unless is_current_manager_of(@company)
			warning_unauthorized
			redirect_back_or_default('/index')
			return
		end
	end

end
