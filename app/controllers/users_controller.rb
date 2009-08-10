class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.paginate(:per_page => 10, :page => params[:page])
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
    @user = User.find(params[:id])

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
        # flash[:notice] = control_action_label('notice')
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
        # flash[:notice] = control_action_label('notice')
        flash[:notice] = I18n.t(:successful_update)
        redirect_to root_url
      else
        render :action => 'edit'
      end
    end
  end
end

###### original source 
# class UsersController < ApplicationController
#   helper :teammate
# 
#   before_filter :build_user
#   before_filter :login_required, :except =>[:new, :create, :create_new_user, :third_party]
#   before_filter :get_user, :only => [:show]

  # def index
  #   store_location
  #   @users = current_user.page_mates(params[:page])        
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @users }
  #   end
  # end

#   # def list
#   #   store_location
#   #   unless current_user.groups.empty?
#   #     @users = User.paginate(:all, :conditions => ['id not in (select user_id from roles_users where role_id = 72440) ' +
#   #       'and id not in (select user_id from groups_users where group_id in (?)) and archive = false',
#   #       current_user.groups], :order => 'name', :page => params[:page])
#   #     else
#   #       @users = User.paginate(:all,
#   #       :conditions => ['id not in (select user_id from roles_users where role_id = 72440) and archive = false'], 
#   #       :order => 'name', :page => params[:page])
#   #     end
#   #     
#   #     @non_member = true
#   #     render :template => '/users/index' 
#   #   end
#     
#     def search
#       count = User.count_by_solr(params[:search])
#       @users = User.paginate_all_by_solr(params[:search], :page => params[:page], :total_entries => count, :limit => 25, :offset => 1)
# 
#       # @non_member = true
#       # @users = User.paginate_all_by_solr(params[:search].to_s, :page => params[:page])
#       render :template => '/users/index'
#     end
#     
#     def recent_activity
#       @user = current_user      
#     end
# 
#     def show
#       store_location      
# 
#       if @user.my_members?(current_user)
#         @previous = User.previous(@user, current_user.groups)
#         @next = User.next(@user, current_user.groups)
#         @scorecard = @user.scorecards
#       end
#     end
# 
#     def create_user_group
#       @group = Group.new
#       @group.attributes = params[:group] unless params[:group].nil?
#       @group.timezone_id = params[:timezone][:id]
#       @group.sport_id = params[:sport][:id]
#       @group.ema = current_user.email
#       @group.name = @group.name if @group.name.nil?
#       @group.description = "#{t(:no_description) }" if @group.description.nil?
#       @group.save!
#       @group.create_group_details
#       GroupsUsers.create_groups_users(@group.id, current_user.id)
#     end
# 
#     def edit
#       store_location
#       @user = User.find(params[:id])
#       if @user.can_modify?(current_user)
#         # render :template =>  '/layouts/current/edit' if @main
#         # render :template => '/user/edit'
#       end
#     end
# 
#     def update
#       @user = User.find(params[:id])
# 
#       if @user.update_attributes(params[:user])
#         redirect_to :action => 'show', :id => @user
#       else
#         render :action => 'edit' 
#       end
#     end  
# 
#     def third_party
#       store_location
#       @user = current_user
#     end
# 
#     def set_sub_manager   
#       @user = User.find(params[:id])
#       @group = Group.find(params[:group]) 
# 
#       permit "manager of :group", :group => @group do
#         if @user
#           @group.accepts_role 'sub_manager', @user
# 
#           flash[:notice] = "#{t(:add_sub_manager)} #{t(:updated)}"
#           redirect_back_or_default('/index')
#           return
#         else
#           flash[:notice] = "#{t(:add_sub_manager)} #{t(:updated)}"
# 
#           redirect_back_or_default('/index')
#           return
#         end
#       end  
#       redirect_back_or_default('/index')    
#     end 
# 
#     def remove_sub_manager  
#       @user = User.find(params[:id])
#       @group = Group.find(params[:group]) 
# 
#       permit "manager of :group", :group => @group do
#         if @user
#           @group.accepts_no_role 'sub_manager', @user
# 
#           flash[:notice] = "#{t(remove_sub_manager)} #{t(:updated)}"
#           redirect_back_or_default('/index')
#           return
#         else
#           flash[:notice] = "#{t(:remove_sub_manager)} #{t(:not_updated)}"
#           redirect_back_or_default('/index')
#           return
#         end
#       end  
#       redirect_back_or_default('/index')    
#     end  
# 
#     def set_gravatar
#       @user = User.find(params[:id])
#       theGravatar = Gravatar.new(@user.email)
#       if theGravatar.has_gravatar? and @user.default_avatar != theGravatar.url
#         @user.default_avatar = theGravatar.u 
#         @user.has_gravatar = true                
#         @user.save!
#           flash[:notice] = t(:gravatar_received)
#           redirect_back_or_default('/index')
#           return
#   
#       else 
#         @user.has_gravatar = false
#         @user.default_avatar = "default_avatar.jpg" 
#         @user.save!
#         flash[:notice] = t(:gravatar_not_received)              
#       end
#         redirect_back_or_default('/index')
#     end
#     
#     def set_subscription   
#       @user = User.find(params[:id])
#       @group = Group.find(params[:group]) 
# 
#       permit "manager of :group", :group => @group do
#         if @user
#           @group.accepts_role 'subscription', @user
# 
#           flash[:notice] = "#{t(:add_subscription)} #{t(:updated)}"
#           redirect_back_or_default('/index')
#           return
#         else
#           flash[:notice] = "#{t(:add_subscription)} #{t(:not_updated)}"
#           redirect_back_or_default('/index')
#           return
#         end
#       end  
#       redirect_back_or_default('/index')    
#     end 
# 
#     def remove_subscription 
#       @user = User.find(params[:id])
#       @group = Group.find(params[:group]) 
# 
#       permit "manager of :group", :group => @group do
#         if @user
#           @group.accepts_no_role 'subscription', @user
# 
#           flash[:notice] = "#{t(:remove_subscription)} #{t(:updated)}"
#           redirect_back_or_default('/index')
#           return
#         else
#           flash[:notice] = "#{t(:remove_subscription)} #{t(:not_updated)}"
#           redirect_back_or_default('/index')
#           return
#         end
#       end  
#       redirect_back_or_default('/index')    
#     end
# 
#     def set_moderator   
#       @user = User.find(params[:id])
#       @group = Group.find(params[:group]) 
# 
#       permit "manager of :group", :group => @group do
#         if @user
#           @group.accepts_role 'moderator', @user
# 
#           flash[:notice] = "#{t(:add_moderator)} #{t(:updated)}"
#           redirect_back_or_default('/index')
#           return
#         else
#           flash[:notice] = "#{t(:add_moderator)} #{t(:not_updated)}"
#           redirect_back_or_default('/index')
#           return
#         end
#       end  
#       redirect_back_or_default('/index')    
#     end 
# 
#     def remove_moderator
#       @user = User.find(params[:id])
#       @group = Group.find(params[:group]) 
# 
#       permit "manager of :group", :group => @group do
#         if @user
#           @group.accepts_no_role 'moderator', @user
# 
#           flash[:notice] = "#{t :remove_moderator } #{t(:updated)}"
#           redirect_back_or_default('/index')
#           return
#         else
#           flash[:notice] = "#{t :remove_moderator } #{t(:not_updated)}"
#           redirect_back_or_default('/index')
#           return
#         end
#       end  
#       redirect_back_or_default('/index')    
#     end
# 
#     def set_reliable
#       @user = User.find(params[:id])
#       available = "Medium"
# 
#       case @user.default_available
#       when "Low" then available = "Medium"
#       when "Medium" then available = "High"
#       when "High" then available = "Low"
#       end
# 
#       if @user.update_attribute("default_reliable", available)
#         flash[:notice] = "#{t :modified_reliable }, #{@user.name}..."
#         redirect_to :action => 'show', :id => @user
#       else
#         render :action => 'index'
#       end
#     end
# 
#     def set_available
#       @user = User.find(params[:id])
# 
#       if @user.update_attribute("default_available", !@user.default_available)
#         @user.update_attribute("default_email", @user.default_available)                # set ema to = available  
# 
#         flash[:notice] = "#{t :is_available_user }, #{@user.name}..."
#         redirect_back_or_default('/index')
#       else
#         render :action => 'index'
#       end
#     end
# 
#     def set_email
#       @user = User.find(params[:id])
# 
#       if @user.update_attribute("message_notification", !@user.message_notification)
#         flash[:notice] = "#{t :modified_ema }, #{@user.name}..."
#         redirect_back_or_default('/index')
#       else
#         render :action => 'index'
#       end
#     end
# 
#     def set_openid
#       @user = User.find(params[:id])
# 
#       if @user.update_attribute("openid_login", !@user.openid_login)
#         flash[:notice] = "#{t :modified_openid }, #{@user.name}..."
#         redirect_back_or_default('/index')
#       else
#         render :action => 'index'
#       end
#     end
# 
#     def set_phone
#       @user = User.find(params[:id])
# 
#       if @user.update_attribute("private_phone", !@user.private_phone)
#         flash[:notice] = "#{t :modified_phone }, #{@user.name}..."
#         redirect_back_or_default('/index')
#       else
#         render :action => 'index'
#       end
#     end
# 
#     def set_profile
#       @user = User.find(params[:id])
# 
#       if @user.update_attribute("private_profile", !@user.private_profile)
#         flash[:notice] = "#{t :modified_profile }, #{@user.name}..."
#         redirect_back_or_default('/index')
#       else
#         render :action => 'index'
#       end
#     end
# 
#     def set_injury
#       @user = User.find(params[:id])
# 
#       if @user.update_attribute("injury", !@user.injury)
#         flash[:notice] = "#{t :injury_profile } #{:updated }"
#         if(params[:url]) == 'show'
#           redirect_to :action => 'show', :id => @user
#         else
#           redirect_to :action => 'index'
#         end
#       else
#         flash[:notice] = "#{t :injury_profile } #{t(:not_updated)}"
#         render :action => 'index'
#       end
#     end
# 
#     def create
#       logout_keeping_session!
#       if using_open_id?
#         session[:user_params] = params[:user] if params[:user]
#         authenticate_with_open_id(params[:openid_url],
#         :required => [:nickname, :email],
#         :option => [:fullname, :country, :language, :timezone], :return_to => open_id_create_url) do |result, identity_url|
#           if result.successful?
#             if @actualUser = User.find_by_identity_url(identity_url)
#               redirect_to :controller => 'sessions'
#               return
#             end
# 
#             create_new_user(:identity_url => identity_url)
#             session[:locale] = @user.language.to_s.downcase unless @user.language.nil?
#           else
#             failed_creation(result.message || "#{t(:something_wrong) }")
#           end
#         end
#       end
#     end
# 
#     protected
# 
#     def create_new_user(attributes)
#       if @user.update_attributes(attributes) && @user.errors.empty?
#         the_login =  @user.identity_url.gsub('http:', '').gsub('.myopenid.com','').gsub('/','')
# 
#         @user.update_attribute('name', the_login) 
#         @user.update_attribute('login', the_login) 
# 
#         @user.update_attribute('login', params['openid.sreg.nickname']) unless params['openid.sreg.nickname'].nil?
#         @user.update_attribute('name', params['openid.sreg.fullname']) unless params['openid.sreg.fullname'].nil?
#         @user.update_attribute('email', params['openid.sreg.email']) unless params['openid.sreg.email'].nil?
#         @user.update_attribute('time_zone', params['openid.sreg.timezone']) unless params['openid.sreg.timezone'].nil?
#         @user.update_attribute('country', params['openid.sreg.country']) unless params['openid.sreg.country'].nil?
#         @user.update_attribute('language', params['openid.sreg.language']) unless params['openid.sreg.language'].nil?
#         @user.save!
# 
#         successful_creation
#       else
#         failed_creation
#       end
#     end
# 
#     def successful_creation
#       # Protects against session fixation attacks, causes request forgery
#       # protection if visitor resubmits an earlier form using back
#       # button. Uncomment if you understand the tradeoffs.
#       # reset session
#       self.current_user = @user # !! now logged in
#       redirect_back_or_default('/')
#       flash[:notice] = t(:thanx_sign_up)
#     end
# 
#     def failed_creation(message = "#{t :could_not_setup_account }")
#       flash[:error] = message
#       render :action => 'new'
#     end
# 
#     def build_user
#       @user = User.new
#     end
# 
# 
#     private
#     def get_user
#       @user = User.find(params[:id])
#     end
#   end
