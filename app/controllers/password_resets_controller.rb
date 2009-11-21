class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  ssl_required :new, :create, :edit, :update
  
  def new
    render
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user and verify_recaptcha() 
      @user.deliver_password_reset_instructions!
      flash[:notice] = I18n.t(:password_instructions) #+ I18n.t("#{ verify_recaptcha() }_value")
      redirect_to root_url
    else
      flash[:notice] = I18n.t(:user_not_found)
      render :action => :new
    end
  end
  
  def edit
    render
  end
 
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save and verify_recaptcha() 
      flash[:notice] = I18n.t(:password_updated) + I18n.t("#{ verify_recaptcha() }_value")
      redirect_to root_url
    else
      render :action => :edit
    end
  end
 
  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash[:notice] = I18n.t(:password_issue)
        redirect_to root_url
      end
    end
end