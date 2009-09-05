class PracticesController < ApplicationController
  before_filter :require_user
  
  before_filter :get_practice, :only => [:show, :edit, :update, :destroy, :team_roster, :team_last_minute, :team_no_show, :team_unavailable]
  before_filter :get_group, :only =>[:new]
  before_filter :get_match_type, :only => [:team_roster, :team_last_minute, :team_no_show, :team_unavailable]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]
  before_filter :has_member_access, :only => :show
  
  def index
    @practices = Practice.current_practices(current_user, params[:page])
  end

  def list    
    @practices = Practice.previous_practices(current_user, params[:page])
    render :template => '/practices/index'       
  end
  
  def show
    store_location
    @practice = Practice.find(params[:id])
    @group = @practice.group
    @previous = Practice.previous(@practice)
    @next = Practice.next(@practice)
  end
  
  def new    
    # editing is limited to administrator or creator
      @practice = Practice.new
      @practice.group_id = @group.id
      @practice.sport_id = @group.sport_id
      @practice.marker_id = @group.marker_id
      @practice.time_zone = @group.time_zone

      @lastPractice = Practice.find(:first, :conditions => ["id = (select max(id) from practices where group_id = ?) ", @group.id])    
      if !@lastPractice.nil?
        @practice = @lastPractice 
        @practice.starts_at = @lastPractice.starts_at + 7.days
        @practice.ends_at = @lastPractice.ends_at + 7.days
        @practice.reminder = @lastPractice.reminder
      end
      @recipients = User.find_all_by_mates(current_user)
  end
  

  
  def create
    @practice = Practice.new(params[:practice])
    
    if params[:recipient_ids]
      @recipients = User.find(params[:recipient_ids])
    end
    
    if @practice.save
      
      if @recipients
        # @recipients.each {|recipient| @practice.attend(recipient) }
      end
      
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @practice
    else
      render :action => 'new'
    end
  end
  
  def edit
    @practice = Practice.find(params[:id])
  end
  
  def update
    @practice = Practice.find(params[:id])
    if @practice.update_attributes(params[:practices])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @practice
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @practice = Practice.find(params[:id])
    @practice.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to practices_url
  end

    private
    def has_manager_access
      unless current_user.is_manager_of?(@practice.group)
        flash[:warning] = I18n.t(:unauthorized)
        redirect_back_or_default('/index')
        return
      end
    end

    def has_member_access
      unless current_user.is_member_of?(@practice.group)
        flash[:warning] = I18n.t(:unauthorized)
        redirect_back_or_default('/index')
        return
      end
    end

    def get_practice
      @practice = Practice.find(params[:id])
      @group = @practice.group
    end

    def get_match_type 
      store_location 
      unless current_user.is_member_of?(@practice.group)  
        redirect_to :action => 'index'
        return
      end
      @match_type = Type.find(:all, :conditions => "id in (1, 2, 3, 4)", :order => "id")
    end

    def get_group
      # depended on number of groups for current user 
      # a group id is needed
      if current_user.groups.count == 0
        redirect_to :controller => 'groups', :action => 'new' 
        return

      elsif current_user.groups.count == 1 
        @group = current_user.groups.find(:first)

      elsif current_user.groups.count > 1 and !params[:id].nil?
        @group = Group.find(params[:id])

      elsif current_user.groups.count > 1 and params[:id].nil? 
        redirect_to :controller => 'groups', :action => 'index' 
        return
      end

    end
  end






#    
#    def search
#      count = Practice.count_by_solr(params[:search])
#      @practices = Practice.paginate_all_by_solr(params[:search], :page => params[:page], :total_entries => count, :limit => 25, :offset => 1)
# 
#      render :template => '/practices/index'
#    end
# 
#     
#     # def index
#     #   @month_practices = Practice.monthly_practices(@date).user_practices(current_user)
#     #   unless filter_by_day?
#     #     @practices = @month_practices
#     #   else
#     #     @practices = Practice.daily_practices(@date).user_practices(current_user)
#     #   end
#     # 
#     #   respond_to do |format|
#     #     format.html # index.html.erb
#     #     format.xml  { render :xml => @practices }
#     #   end
#     # end
# 
#     # def show
#     #   @month_practices = Practice.monthly_practices(@date).user_practices(current_user)
#     #   @attendees = @practice.attendees.paginate(:page => params[:page], 
#     #                                          :per_page => RASTER_PER_PAGE)
#     # 
#     #   respond_to do |format|
#     #     format.html # show.html.erb
#     #     format.xml  { render :xml => @practice }
#     #   end
#     # end
# 

# 
#     def edit
#     end
# 
#     def create
#       @group = Group.find(params[:group][:id]) unless params[:group][:id].nil?
#       permit "manager of :group or creator of :group or maximo", :group => @group do
#        @practice = Practice.new(params[:practice]) #.merge(:user => current_user))
#        @practice.group_id = params[:group][:id]
#        
# 
#       respond_to do |format|
#         if @practice.save
#           flash[:notice] = 'Practice was successfully created.'
#           format.html { redirect_to(@practice) }
#           format.xml  { render :xml => @practice, :status => :created, :location => @practice }
#         else
#           format.html { render :action => "new" }
#           format.xml  { render :xml => @practice.errors, :status => :unprocessable_entity }
#         end
#       end
#       end
#     end
# 
#     def update
#       respond_to do |format|
#         if @practice.update_attributes(params[:practice])
#           flash[:notice] = 'Practice was successfully updated.'
#           format.html { redirect_to(@practice) }
#           format.xml  { head :ok }
#         else
#           format.html { render :action => "edit" }
#           format.xml  { render :xml => @practice.errors, :status => :unprocessable_entity }
#         end
#       end
#     end
# 
#     def destroy
#       @practice.destroy
# 
#       respond_to do |format|
#         format.html { redirect_to(practices_url) }
#         format.xml  { head :ok }
#       end
#     end
# 
#     def attend
#       if @practice.attend(current_user)
#         flash[:notice] = "You are attending this practice."
#         redirect_to @practice
#       else
#         flash[:error] = "You can only attend once."
#         redirect_to @practice
#       end
#     end
# 
#     def unattend
#       if @practice.unattend(current_user)
#         flash[:notice] = "You are not attending this practice."
#         redirect_to @practice
#       else
#         flash[:error] = "You are not attending this practice."
#         redirect_to @practice
#       end
#     end
# 
#     private
# 
#       def in_progress
#         flash[:notice] = "Work on this feature is in progress."
#         redirect_to home_url
#       end
# 
#       def authorize_show
#         if (@practice.only_contacts? and
#             not (@practice.user.contact_ids.include?(current_user.id) or
#                  current_user?(@practice.user) or current_user.admin?))
#           redirect_to home_url 
#         end
#       end
# 
#       def authorize_change
#         redirect_to home_url unless current_user?(@practice.user)
#       end
# 
#       def authorize_destroy
#         can_destroy = current_user?(@practice.user) || current_user.admin?
#         redirect_to home_url unless can_destroy
#       end
# 
#       def load_date
#         if @practice
#           @date = @practice.start_time
#         else
#           now = Time.now
#           year = (params[:year] || now.year).to_i
#           month = (params[:month] || now.month).to_i
#           day = (params[:day] || now.mday).to_i
#           @date = DateTime.new(year,month,day)
#         end
#       rescue ArgumentError
#         @date = Time.now
#       end
# 
#       def filter_by_day?
#         !params[:day].nil?
#       end
# 
#       def load_practice
#         @practice = Practice.find(params[:id])
#       end
#       
#       def get_practice
#         @practice = Practice.find(params[:id])
#       end
# 
#       def get_group
#         # depended on number of groups for current user 
#         # a group id is needed
#         if current_user.groups.count == 0
#           redirect_to :controller => 'groups', :action => 'new' 
#           return
# 
#         elsif current_user.groups.count == 1 
#           @group = current_user.groups.find(:first)
# 
#         elsif current_user.groups.count > 1 and !params[:id].nil?
#           @group = Group.find(params[:id])
# 
#         elsif current_user.groups.count > 1 and params[:id].nil? 
#           redirect_to :controller => 'groups', :action => 'index' 
#           return
#         end
# 
#       end
# 
#   end
# 
