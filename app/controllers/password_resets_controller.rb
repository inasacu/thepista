class PasswordResetsController < ApplicationController

  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user

	def create
		@user = User.find_by_email(params[:email])

		if DISPLAY_RECAPTCHA 
			unless verify_recaptcha   
				flash[:warning] = I18n.t(:recaptcha_failure)
				render :action => :new
				return
			end
		end

		if @user
			@user.password_reset_instructions!
			flash[:success] = I18n.t(:password_instructions)
			redirect_to root_url
		else
			flash[:success] = I18n.t(:password_instructions_issue)
			render :action => :new
			return
		end 

	end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

		if DISPLAY_RECAPTCHA 
			unless verify_recaptcha   
				flash[:warning] = I18n.t(:recaptcha_failure)
				render :action => :new
				return
			end
		end
    
    # if verify_recaptcha      
      if @user.save
        flash[:success] = I18n.t(:password_updated) 
        redirect_to root_url
      else
        flash[:success] = I18n.t(:password_instructions_issue)
        render :action => :edit
        return
      end 
    # else 
    #   flash[:notice] = I18n.t(:recaptcha_failure)
    #   render :action => :edit
    #   return
    # end
    
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
