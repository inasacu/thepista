class SurveysController < ApplicationController
	before_filter :require_user
	before_filter :get_survey, :only => [:edit, :update]

	def index
		@surveys = Survey.page(params[:page]).order('surveys.created_at DESC')
	end

	def new
		@survey = Survey.new
	end

	def create
		@survey = Survey.new(params[:survey])		
		@user = current_user
		@survey.user = @user

		if @survey.save 
			successful_create
			redirect_to :surveys
		else
			render :action => 'new'
		end
	end

	def edit
		set_the_template('surveys/new')
	end

	def update
		if @survey.update_attributes(params[:survey]) 
			controller_successful_update
			redirect_to :surveys
		else
			render :action => 'edit'
		end
	end



	private
	def get_survey
		@survey = Survey.find(params[:id])
	end

end
