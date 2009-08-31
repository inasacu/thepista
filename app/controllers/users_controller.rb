class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:signup, :new, :create]
  before_filter :require_user, :only => [:index, :show, :edit, :update] 
  
  before_filter :get_user, :only => [:show, :set_available, :set_private_phone, :set_private_profile, :set_enable_comments, 
                                 :set_teammate_notification, :set_message_notification, :set_comment_notification] 
  before_filter :get_user_group, :only =>[:set_sub_manager, :remove_sub_manager, :set_subscription, 
                                          :remove_subscription, :set_moderator, :remove_moderator]
  
  
  # GET /users
  # GET /users.xml
  def index
    store_location
    @users = current_user.page_mates(params[:page])
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    store_location
    # @user = User.find(params[:id])

    # if @user.my_members?(current_user)
      @previous = User.previous(@user, current_user.groups)
      @next = User.next(@user, current_user.groups)
    # end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/signup
  # GET /users/signup.xml
  def signup
    @user = User.new
    respond_to do |format|
      format.html # signup.html.erb
      format.xml  { render :xml => @user }
    end
  end  

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    @user.save do |result|
      if result
        flash[:notice] = I18n.t(:successful_signup)
        redirect_to root_url
      else
        render :action => 'signup'
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = current_user

    @user.attributes = params[:user]
    @user.save do |result|
      if result
        flash[:notice] = I18n.t(:successful_update)
        redirect_back_or_default('/index')
        return
      else
        render :action => 'edit'
      end
    end
  end

  def petition
    if current_user.requested_managers.empty? and current_user.pending_managers.empty?  
      flash[:notice] = I18n.t(:petition_no)
      redirect_back_or_default('/index')
      return
    end
    
    unless current_user.requested_managers.empty?
      @requested_teammates = Teammate.find(:all, :conditions => ["manager_id = ? and status = 'pending'", current_user.id])
    end
    unless current_user.pending_managers.empty? 
      @pending_teammates = Teammate.find(:all, :conditions => ["user_id = ? and status = 'pending'", current_user.id])
    end 
  end



    
#     def search
#       count = User.count_by_solr(params[:search])
#       @users = User.paginate_all_by_solr(params[:search], :page => params[:page], :total_entries => count, :limit => 25, :offset => 1)
# 
#       # @non_member = true
#       # @users = User.paginate_all_by_solr(params[:search].to_s, :page => params[:page])
#       render :template => '/users/index'
#     end

    def set_sub_manager 
      unless current_user.is_manager_of?(@group)
        flash[:notice] = I18n.t(:unauthorized)  
        return
      end
      @user.has_role!(:sub_manager, @group)
      flash[:notice] = I18n.t(:sub_manager_updated)
      redirect_back_or_default('/index')
    end

    def remove_sub_manager 
      unless current_user.is_manager_of?(@group)
        flash[:notice] = I18n.t(:unauthorized)  
        return
      end
      @user.has_no_role!(:sub_manager, @group)
      flash[:notice] = I18n.t(:sub_manager_updated)
      redirect_back_or_default('/index')
    end

    def set_subscription 
      unless current_user.is_manager_of?(@group)
        flash[:notice] = I18n.t(:unauthorized)  
        return
      end
      @user.has_role!(:subscription, @group)
      flash[:notice] = I18n.t(:subscription_updated)
      redirect_back_or_default('/index')
    end 
    
    def remove_subscription 
      unless current_user.is_manager_of?(@group)
        flash[:notice] = I18n.t(:unauthorized)  
        return
      end
      @user.has_no_role!(:subscription, @group)
      flash[:notice] = I18n.t(:subscription_updated)
      redirect_back_or_default('/index')
    end
    
    def set_moderator 
      unless current_user.is_manager_of?(@group)
        flash[:notice] = I18n.t(:unauthorized)  
        return
      end
      @user.has_role!(:moderator, @group)
      flash[:notice] = I18n.t(:moderator_updated)
      redirect_back_or_default('/index')
    end 
    
    def remove_moderator 
      unless current_user.is_manager_of?(@group)
        flash[:notice] = I18n.t(:unauthorized)  
        return
      end
      @user.has_no_role!(:moderator, @group)
      flash[:notice] = I18n.t(:moderator_updated)
      redirect_back_or_default('/index')
    end

    def set_available
      if @user.update_attribute("available", !@user.available)
        @user.update_attribute("available", @user.available)  

        flash[:notice] = I18n.t(:successful_update)
        redirect_back_or_default('/index')
      else
        render :action => 'index'
      end
    end

    def set_private_phone
      if @user.update_attribute("private_phone", !@user.private_phone)
        @user.update_attribute("private_phone", @user.private_phone)  

        flash[:notice] = I18n.t(:successful_update)
        redirect_back_or_default('/index')
      else
        render :action => 'index'
      end
    end
    
    def set_private_profile
      if @user.update_attribute("private_profile", !@user.private_profile)
        @user.update_attribute("private_profile", @user.private_profile)  

        flash[:notice] = I18n.t(:successful_update)
        redirect_back_or_default('/index')
      else
        render :action => 'index'
      end
    end  

    def set_enable_comments
      if @user.update_attribute("enable_comments", !@user.enable_comments)
        @user.update_attribute("enable_comments", @user.enable_comments)  

        flash[:notice] = I18n.t(:successful_update)
        redirect_back_or_default('/index')
      else
        render :action => 'index'
      end
    end  

    def set_teammate_notification
      if @user.update_attribute("teammate_notification", !@user.teammate_notification)
        @user.update_attribute("teammate_notification", @user.teammate_notification)  

        flash[:notice] = I18n.t(:successful_update)
        redirect_back_or_default('/index')
      else
        render :action => 'index'
      end
    end  

    def set_message_notification
      if @user.update_attribute("message_notification", !@user.message_notification)
        @user.update_attribute("message_notification", @user.message_notification)  

        flash[:notice] = I18n.t(:successful_update)
        redirect_back_or_default('/index')
      else
        render :action => 'index'
      end
    end  

    def set_comment_notification
      if @user.update_attribute("blog_comment_notification", !@user.blog_comment_notification)
        @user.update_attribute("blog_comment_notification", @user.blog_comment_notification)  

        flash[:notice] = I18n.t(:successful_update)
        redirect_back_or_default('/index')
      else
        render :action => 'index'
      end
    end  
    
    
private
  def get_user
    @user = User.find(params[:id])
  end
  
  def get_user_group
    @user = User.find(params[:id])
    @group = Group.find(params[:group])
  end
end
