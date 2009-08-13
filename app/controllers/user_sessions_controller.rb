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
end
