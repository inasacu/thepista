require 'rubygems'
require 'rqrcode'

class UsersController < ApplicationController
  before_filter :require_no_user,     :only => [:signup, :create, :rpx_new, :rpx_create, :rpx_associate]
  before_filter :require_user,        :only => [:index, :list, :show, :notice, :edit, :update, :petition, :recent_activity] 
    
  before_filter :get_sports,          :only => [:new, :edit, :signup, :rpx_new]

  before_filter :get_user_member,     :only => [:show, :notice] 
  before_filter :get_user_manager,    :only => [:set_available]
  
  before_filter :get_user_self,       :only => [:set_private_phone, :set_private_profile, :set_enable_comments, :set_looking, 
                                                :set_teammate_notification, :set_message_notification, :set_blog_notification, 
                                                :set_forum_notification, :set_last_minute_notification]
                                                                                                         
  before_filter :get_user_group,      :only =>[:set_manager, :remove_manager, :set_sub_manager, :remove_sub_manager, 
                                               :set_subscription, :remove_subscription, :set_moderator, :remove_moderator]
                                          
  before_filter :setup_rpx_api_key,   :only => [:rpx_new, :rpx_create, :rpx_associate]
  
  before_filter :has_member_access,   :only => [:rate]
  
  # ssl_required :signup, :new, :create
  # ssl_allowed :index, :list, :show
  
  def index
    # store_location
    # @users = current_user.page_mates(params[:page])
    redirect_to root_url
  end
  
  
  def list
    # store_location
    # @users = current_user.other_mates(params[:page])
    # render :template => '/users/index' 
    redirect_to root_url      
  end

  def show
    store_location

    # linkedin information
    @client = ""
    @profile = ""
    @no_linkedin_profile = (@user.linkedin_url.nil? or @user.linkedin_url.blank? or @user.linkedin_url.empty?)
    
    unless @no_linkedin_profile
      @client = LinkedIn::Client.new(APP_CONFIG['linkedin']['api_key'], APP_CONFIG['linkedin']['secret_key'])
      @client.authorize_from_access(@user.linkedin_token, @user.linkedin_secret)
      @profile = @client.profile
    end

    @items = current_user.challenges.find(:all, :conditions => ["ends_at > ?", Time.zone.now])
  end
  
  def notice
    store_location
    render :template => '/users/show'
  end

  def signup
    @user = User.new
  end  

  def new
    redirect_to :signup
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])

    if verify_recaptcha      
      @user.name = @user.email      
      if @user.save
        @user.email_to_name
        @user.email_backup = @user.email
        @user.save
      else
        flash[:warning] = I18n.t(:password_email_conbination_issue)
        redirect_to :signup
        return
      end
      
    else 
      flash[:warning] = I18n.t(:recaptcha_failure)
      redirect_to :signup
      return
    end  
        
    flash[:success] = I18n.t(:successful_create)
    redirect_to @user
  end

  def update
    @user = current_user
    @the_user = User.find(current_user.id)
    
    @user.attributes = params[:user]
    @user.profile_at = Time.zone.now
  
    update_match_profile = (@the_user.technical != @user.technical or @the_user.physical.to_i != @user.physical)
    
    @user.save do |result|
      
      # update user profile for current match
      if update_match_profile
        Match.user_upcoming_match(@user).each do |match|
          match.technical = @user.technical.to_i
          match.physical = @user.physical.to_i
          match.save!
        end
      end
      
      if result
        flash[:success] = I18n.t(:successful_update)
        redirect_to :action => 'show'
        return
      else
        render :action => 'edit'
      end
    end
  end

  def rate
    # @user.rate(params[:stars], current_user, params[:dimension])   
    # render :update do |page|
    #   page.replace_html @user.wrapper_dom_id(params), ratings_for(@user, params.merge(:wrap => false))
    #   page.visual_effect :highlight, @user.wrapper_dom_id(params)
    # end

    @user.rate(params[:stars], current_user, params[:dimension])
    average = @user.rate_average(true, params[:dimension])
    width = (average / @user.class.max_stars.to_f) * 100
    render :json => {:id => @user.wrapper_dom_id(params), :average => average, :width => width}
  end
  
  def recent_activity
    @user = current_user    
    redirect_to :action => 'index'  
    return
  end
  
  def petition
    redirect_to root_url
    return
    
    # if current_user.requested_managers.empty? and current_user.pending_managers.empty?  
    #   redirect_to root_url
    #   return
    # end
    # 
    # unless current_user.requested_managers.empty?
    #   @requested_teammates = Teammate.find(:all, :conditions => ["manager_id = ? and status = 'pending'", current_user.id])
    # end
    # unless current_user.pending_managers.empty? 
    #   @pending_teammates = Teammate.find(:all, :conditions => ["user_id = ? and status = 'pending'", current_user.id])
    # end 
  end

  def third_party
    RPXNow.api_key = APP_CONFIG['rpx_api']['key']
    store_location
    @user = current_user
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @user }
    end
  end
  
  def remove_openid    
    identifier = params[:openid] 
    RPXNow.unmap(identifier, @current_user.id)
    flash[:notice] = "OpenID #{identifier} #{I18n.t(:removed)}"    
    redirect_back_or_default('/index')
  end

  def search
    count = User.count_by_solr(params[:search])
    @users = User.paginate_all_by_solr(params[:search], :page => params[:page], :per_page => USERS_PER_PAGE, :operator => :or)
    render :template => '/users/index'
  end 

  def set_looking
    if @user.update_attribute("looking", !@user.looking)
      @user.update_attribute("looking", @user.looking)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end 
  
  def set_language
    I18n.locale = "es"   
    I18n.locale = params[:id] if LANGUAGES.include?(params[:id])

    if current_user and LANGUAGES.include?(params[:id])
      @user = current_user
      @user.language = params[:id]
      @user.save!
      redirect_back_or_default('/')
      return
    end
    redirect_to login_url
  end
  
  def set_manager 
    unless current_user.is_creator_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)  
      return
    end
    @user.has_role!(:manager, @group)
    flash[:notice] = I18n.t(:manager_updated)
    redirect_back_or_default('/index')
  end

  def remove_manager 
    unless current_user.is_creator_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)  
      return
    end
    @user.has_no_role!(:manager, @group)
    flash[:notice] = I18n.t(:manager_updated)
    redirect_back_or_default('/index')
  end

  def set_sub_manager 
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)  
      return
    end
    @user.has_role!(:sub_manager, @group)
    flash[:notice] = I18n.t(:sub_manager_updated)
    redirect_back_or_default('/index')
  end

  def remove_sub_manager 
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)  
      return
    end
    @user.has_no_role!(:sub_manager, @group)
    flash[:notice] = I18n.t(:sub_manager_updated)
    redirect_back_or_default('/index')
  end

  def set_subscription 
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)  
      return
    end
    @user.has_role!(:subscription, @group)
    Fee.set_season_player(@user, @group, true)
    
    flash[:notice] = I18n.t(:subscription_updated)
    redirect_back_or_default('/index')
  end 

  def remove_subscription 
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)  
      return
    end
    @user.has_no_role!(:subscription, @group)
    Fee.set_season_player(@user, @group, false)
    
    flash[:notice] = I18n.t(:subscription_updated)
    redirect_back_or_default('/index')
  end

  def set_moderator 
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)  
      return
    end
    @user.has_role!(:moderator, @group)
    flash[:notice] = I18n.t(:moderator_updated)
    redirect_back_or_default('/index')
  end 

  def remove_moderator 
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)  
      return
    end
    @user.has_no_role!(:moderator, @group)
    flash[:notice] = I18n.t(:moderator_updated)
    redirect_back_or_default('/index')
  end

  def set_available
    if @user.update_attribute("available", !@user.available)
      @user.update_attribute("available", @user.available)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_private_phone
    if @user.update_attribute("private_phone", !@user.private_phone)
      @user.update_attribute("private_phone", @user.private_phone)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_private_profile
    if @user.update_attribute("private_profile", !@user.private_profile)
      @user.update_attribute("private_profile", @user.private_profile)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_last_minute_notification
    if @user.update_attribute("last_minute_notification", !@user.last_minute_notification)
      @user.update_attribute("last_minute_notification", @user.last_minute_notification)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_enable_comments
    if @user.update_attribute("enable_comments", !@user.enable_comments)
      @user.update_attribute("enable_comments", @user.enable_comments)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end  

  def set_teammate_notification
    if @user.update_attribute("teammate_notification", !@user.teammate_notification)
      @user.update_attribute("teammate_notification", @user.teammate_notification)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end  

  def set_message_notification
    if @user.update_attribute("message_notification", !@user.message_notification)
      @user.update_attribute("message_notification", @user.message_notification)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end  

  def set_blog_notification
    if @user.update_attribute("blog_comment_notification", !@user.blog_comment_notification)
      @user.update_attribute("blog_comment_notification", @user.blog_comment_notification)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end  

  def set_forum_notification
    if @user.update_attribute("forum_comment_notification", !@user.forum_comment_notification)
      @user.update_attribute("forum_comment_notification", @user.forum_comment_notification)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end  

  def rpx_new
    # Token should be in the session from UserSessionsController.rpx_create...
    data = RPXNow.user_data(session[:rpx_token], :extended => 'true')
    if data.blank?
      flash[:error] = I18n.t(:rpx_third_party_error)
      redirect_to login_path
    else
      # Save the identifier in the session to save a lookup...
      identifier = data[:identifier]
      session[:rpx_identifier] = identifier
      name = params[:name] || data[:name] || data[:displayName] || data[:nickName]
      email = params[:email] || data[:verifiedEmail] || data[:email]
      login = params[:preferredUsername]
      
      @user = User.new
      @user.name = name
      @user.email = email
      
      existing_user = User.find_by_email(email)
      if existing_user
        # Handle associating an existing account found by email or login to an OpenID.
        @email = existing_user.nil? ?   email : existing_user.email
        @user_session = UserSession.new(:email => @email)
        @show_openid_association = true
        if existing_user.email == email
          @association_message = I18n.t(:rpx_association_email_msg)
        else
          @association_message = I18n.t(:rpx_association_login_msg)
        end
      end
      
      respond_to do |format|
        format.html
      end
    end
  end
  
  def rpx_create
    @user = User.new(params[:user])
    # We want to save the identifier so we can tell a) that they are an RPX user and b) what provider they used (initially)
    @user.identity_url = session[:rpx_identifier]
    @user.openid_identifier = session[:rpx_identifier]
    @user.active = true

    if @user.save
      # Map this identifier to this user's ID on RPXNow. This is how we know a local account exists
      # for them and saves them from having to "sign up" again when they login with that same OpenID.
      # RPXNow.map(session[:rpx_identifier], @user.id)
      
      # Won't be needing these anymore.
      session[:rpx_identifier] = nil
      session[:rpx_token] = nil
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
      respond_to do |format|
        format.html { render :action => :rpx_new }
      end
    end
  end
  
  def rpx_associate
    @user_session = UserSession.new(:email => params[:user_session][:email], :password => params[:user_session][:password])
    if @user_session.save
      # Map this identifier to this existing user's ID on RPXNow. This way they can login
      # to their existing account with their OpenID.
      RPXNow.map(session[:rpx_identifier], @user_session.user.id)
      # Don't need these in the session anymore.
      session[:rpx_identifier] = nil
      session[:rpx_token] = nil
      respond_to do |format|
        format.html { redirect_back_or_default root_url }
        session[:return_to] = nil
      end
    else
      flash[:error] = I18n.t(:rpx_unable_to_associate)
      respond_to do |format|
        format.html { redirect_to :action => :rpx_new }
      end
    end
  end

  def associate_return
    if params[:error]
      flash[:error] = "#{t :openid_failed }: #{params[:error]}"
      redirect_to :controller => "sessions", :action => "index"
      return
    end

    if !params[:token]
      flash[:notice] = t(:openid_cancelled) 
      redirect_to :controller => "sessions", :action => "index"
      return
    end
  
    data = []     
    RPXNow.user_data(params[:token], APP_CONFIG['rpx_api']['key'], :extended=>'true') { |raw| data = raw['profile'] }

    session[:identifier] = identifier = data["identifier"]
    primary_key = data["primaryKey"]

    if primary_key.nil?
      if current_user.nil?
        flash[:notice] = t(:not_signed_in)
      else
        RPXNow.map(identifier, current_user.id, APP_CONFIG['rpx_api']['key'])
        
        ## assign user to original user
        @lastUser = User.find(:first, :conditions => ["identity_url = ? ", identifier])    
        unless @lastUser.nil?
          @lastUser.update_attributes("name" => current_user.name, "email" => current_user.email, "rpxnow_id" => current_user.id)
          @lastUser.save!
        else
          @lastUser = User.new
          @lastUser.rpxnow_id = current_user.id
          @lastUser.identity_url = identifier
          @lastUser.name = current_user.name
          @lastUser.email = current_user.email
          @lastUser.save!
        end
        
        
        flash[:notice] = "#{identifier} #{t :openid_added }"
      end
      # redirect_to :controller => "sessions", :action => "index"
      redirect_back_or_default('/index')
      return
    else
      if current_user.id == primary_key.to_i
        flash[:notice] = t(:openid_already_added)
        # redirect_to :controller => "sessions", :action => "index"
        redirect_back_or_default('/index')
        return
      else
        # The OpenID was already associated with a different user account.
        @page_title = t(:openid_replace_account) 
        session[:identifier] = identifier
        @other_user = User.find_by_id(primary_key)
        if @user.nil?
          
          RPXNow.unmap(identifier, primary_key, APP_CONFIG['rpx_api']['key'])
          RPXNow.map(identifier, current_user.id, APP_CONFIG['rpx_api']['key'])

          flash[:notice] = "#{identifier} #{t(:openid_added) }"
        end
        # redirect_to :controller => "home", :action => "index" 
      end
    end
      redirect_back_or_default('/index')
  end

   
  protected
  
  def setup_rpx_api_key
    RPXNow.api_key = APP_CONFIG['rpx_api']['key']
  end   

private
  def get_user
    @user = User.find(params[:id])
  end
  
  def get_user_manager
    @user = User.find(params[:id])

    unless current_user.is_user_manager_of?(@user)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end
  
  def get_user_member
    @user = User.find(params[:id])


    if @user.private_profile and DISPLAY_PRIVATE_PROFILE
      unless current_user.is_user_member_of?(@user)    
        flash[:warning] = I18n.t(:user_private_profile)
        redirect_to root_url
        return
      end
    end
  end
  
  def get_user_self
    @user = User.find(params[:id])
    
    unless @user == current_user
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end
  
  def get_user_group
    @user = User.find(params[:id])
    @group = Group.find(params[:group])
  end
  
  def has_member_access
    @user = User.find(params[:id])
    has_access = false
    has_access = current_user.is_user_member_of?(@user)

    unless has_access 
      redirect_to root_url
      return
    end
  end
  
  def get_sports
    @items = Sport.find(:all, :select => "name", :order => "name")
  end
  
end
