class ProspectsController < ApplicationController
	before_filter 	:require_user    
	before_filter 	:get_prospect, :only => [:edit, :update, :show]

	def index
		@prospects = Prospect.where("archive = false and 
																 email is null and 
												 				 email_additional is null").page(params[:page]).order('prospects.created_at')
	end

	def show
		# store_location 
		# render @the_template
		redirect_to :action => 'index'
	end

	def new      
		@prospect = Prospect.new
	end

	def create
		@prospect = Prospect.new(params[:prospect])	

		if @prospect.save 
			successful_create
			redirect_to @prospect
		else
			render :action => 'new'
		end
	end

	def edit
		set_the_template('prospects/new')
	end

	def update
		if @prospect.update_attributes(params[:prospect]) 
			controller_successful_update
			redirect_to prospect_url
		else
			render :action => 'edit'
		end
	end 


	private
	def get_prospect
		@prospect = Prospect.find(params[:id])
	end
end