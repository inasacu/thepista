class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        # flash[:notice] = control_action_label('notice')
        flash[:notice] = I18n.t(:successful_logged_in)
        # redirect_to root_url
        redirect_back_or_default root_url
      else
        # flash[:error] = control_action_label('error')
        flash[:error] = I18n.t(:unsuccessful_logged_in)
        render :action => 'new'
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    # Avoid session fixation attacks. 
    session[:test_that_this_disappears] = 'ok' 
    reset_session 


    # flash[:notice] = control_action_label('notice')
    flash[:notice] = I18n.t(:successful_logged_out)
    #redirect_to root_url
    redirect_back_or_default new_user_session_url 
  end

  def rpx_create
    # RPXNow.api_key = [YOUR RPX KEY]
    RPXNow.api_key = APP_CONFIG['rpx_api']['key']
    data = RPXNow.user_data(params[:token], :extended => 'true')
    if data.blank?
      @user_session = UserSession.new
      flash[:error] = I18n.t(:unauthorized)
      respond_to do |format|
        format.html { render :action => :new }
      end
    else
      # Authentication good.. check if need to "sign up"...
      primary_key = data[:id]
      unless primary_key
        # Need to "sign up", store the token so we can get the data again later...
        session[:rpx_token] = params[:token]
        redirect_to rpx_signup_path
      else
        # This OpenID has already "signed up" and been associated to a local user. They are already
        # authenticated so just create their session for them.
        @user = User.find(primary_key)
        if @user
          UserSession.create(@user)
          respond_to do |format|
            # format.html { redirect_back_or_default home_path }
            format.html { redirect_back_or_default root_url }
          end
        else
          flash[:error] = "Unable to find the user that your third-party account maps to. Please contact support@haypista.com for help."
          respond_to do |format|
            format.html { render :action => :new }
          end
        end
      end
    end
  end

end
