class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
    render
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = I18n.t(:password_instructions)
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
    if @user.save
      flash[:notice] = I18n.t(:password_updated)
      redirect_to account_url
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