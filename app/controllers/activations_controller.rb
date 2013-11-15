class ActivationsController < ApplicationController
  before_filter :require_no_user
	
	def create
		@user = User.find_by_email(params[:email])

		if @user
			@user.activation_reset_instructions!
			flash[:success] = I18n.t(:password_instructions)
			redirect_to root_url
		else
			flash[:success] = I18n.t(:password_instructions_issue)
			render :action => :new
			return
		end 

	end



  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])

    unless @user
      flash[:notice] = I18n.t(:password_instructions_issue)
      redirect_to root_url
      return
    end
  end

end
