class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :verify_recaptcha]
  before_filter :require_user, :only => :destroy

  # ssl_required :new, :create, :rpx_create, :destroy

  def new
    @user_session = UserSession.new
    set_the_template('home/index_zurb')
	render @the_template
  end

  def create   
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
      else
        render :action => 'new'
        return
      end
    end
    redirect_back_or_default root_url    
  end

  # def destroy
    # @user_session = UserSession.find
    # @user_session.destroy

    # # Avoid session fixation attacks. 
    # session[:test_that_this_disappears] = 'ok' 
    # reset_session 
    # # redirect_back_or_default new_user_session_url 
    # redirect_to root_url
  # end

  def rpx_create
    RPXNow.api_key = APP_CONFIG['rpx_api']['key']
    data = RPXNow.user_data(params[:token], :extended => 'true')

    if data.blank?
      @user_session = UserSession.new
      respond_to do |format|
        format.html { render :action => :new }
      end
    else

      # Authentication good... check if need to "sign up"... if user email is listed, then simply login and disrecard mapping id to rpxnow...
      email = data[:verifiedEmail] || data[:email]
      @user = User.find_by_email(email)

      openid_identifier = data[:identifier]
      @user_openid = User.find_by_openid_identifier(openid_identifier)

      if @user

        has_invitations = false
        has_invitations = Invitation.has_sent_invitation(@user)

        if LANGUAGES.include?(I18n.locale)
          @user.language = I18n.locale 
          @user.save!
        end

        UserSession.create(@user)

        respond_to do |format|
          format.html { 
            
            if DISPLAY_INVITATION_AT_LOGIN
              # send user to invitation if last login is older than 21 days
              if (@user.last_login_at < LAST_THREE_DAYS or @user.last_login_at.nil?)
                redirect_to :invite
                return
              end
            end
            
            redirect_back_or_default root_url
          }
        end

      elsif @user_openid
        UserSession.create(@user_openid)
        respond_to do |format|
          format.html { redirect_back_or_default root_url }
        end

      else

        # Authentication good.. check if need to "sign up"...if user has no key assigned in rpxnow add it
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
              format.html { 
                
                if DISPLAY_INVITATION_AT_LOGIN
                  # send user to invitation if last login is older than 21 days
                  if (@user.last_login_at < LAST_THREE_DAYS or @user.last_login_at.nil?)
                    redirect_to :invite
                    return
                  end
                end
                
                redirect_back_or_default root_url
              }
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

    # this code has been set to prevent failure when user goes to myopenid and selects cancel
  rescue RPXNow::ApiError
    redirect_to root_url

  end

end
