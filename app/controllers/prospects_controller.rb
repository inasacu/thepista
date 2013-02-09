class ProspectsController < ApplicationController
	before_filter 	:require_user    
	before_filter 	:get_prospect, :only => [:edit, :update, :show]

	def index


		# and conditions not like '%Frontón%'
		# and conditions not like '%Bádminton%'

		@prospects = Prospect.where("name not like '%Tennis%' and name not like '%Tenis%' and name not like '%Padel%' and
																 conditions not like '%Tenis%' and 
		         										 conditions not like '%Padel%' and 
																 conditions not like '%Squash%' and 
																 conditions not like '%Baloncesto%' and
																 conditions not like '%Balonmano%' and
																 conditions not like '%Atletismo%' and
																 conditions not like '%Golf%' and 
																 conditions not like '%Hockey%' and
																 conditions not like '%Voleibol%' and
																 name not like '%Municipal%' and
																 email is null and 
																 phone is null and 
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