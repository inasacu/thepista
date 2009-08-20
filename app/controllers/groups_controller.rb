class GroupsController < ApplicationController
    before_filter :require_user
    
  def index
    @groups = current_user.groups.paginate :page => params[:page], :order => 'name'  
  end
  
  def list    
    @group = Group.find(params[:id])
    @users = @group.users
  end
  
  def team_list
    @group = Group.find(params[:id]) 
    @users = @group.users
    render :template => '/groups/team_list'    
  end
  
  def show
	  store_location 
    @group = Group.find(params[:id])
  end
  
  def new
    @group = Group.new
    @group.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    
    # @group.sport_id = Sport.find(:first)
    # @marker = Marker.find(params[:marker_id]) unless params[:marker_id].nil?
    # @group.marker_id = @marker.id unless params[:marker_id].nil?
    
    @markers = Marker.find(:all)
    @sports = Sport.find(:all)
    
  end
  
  def create
    @group = Group.new(params[:group])		
    @user = current_user
  # @group.second_team = @group.name + " II" if @group.second_team.nil? 
	#@group.gameday_at = Time.now()
  # @group.description.gsub!(/\r?\n/, "<br>")
  		
    if @group.save and @group.create_group_details(current_user)
      
      # @group.create_group_details(current_user)
             
		# GroupsUsers.join_team(@user, @group)
        # Scorecard.create_user_scorecard(@user, @group)    
        # GroupsMarkers.join_marker(@group, @group.marker)   
         
      flash[:notice] = I18n.t(:successfully_created)
      redirect_to @group
    else
      render :action => 'new'
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:notice] = I18n.t(:successfully_updated)
      redirect_to @group
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = I18n.t(:successfully_destroyed)
    redirect_to group_url
  end



#   
#     # def list
#     #   unless current_user.group.empty?
#     #     @group = Group.paginate(:all, :conditions =>["id not in (?)", current_user.my_group], :order => 'name', :page => params[:page]) 
#     #   else
#     #     @group = Group.paginate(:all, :order => 'name', :page => params[:page])
#     #   end
#     #   
#     #   render :template => '/group/index'     
#     # end  
#     
#     def search
#       count = Group.count_by_solr(params[:search])
#       @group = Group.paginate_all_by_solr(params[:search], :page => params[:page], :total_entries => count, :limit => 25, :offset => 1)
#       
#       # @group = Group.paginate_all_by_solr(params[:search].to_s, :page => params[:page])
#       render :template => '/group/index'
#     end
#   
#     def create
#       @group = Group.new(params[:group])
#   
#       @group.second_team = @group.name + " II" if @group.second_team.nil? 
#       @group.gameday_at = Time.now()
#       @group.description.gsub!(/\r?\n/, "<br>")
#       
#       @user = User.find(current_user.id)
# 
#       if @group.save      
#         @group.create_group_blog_details
#         @group.create_group_details(@user)
#             
#         GroupsUsers.join_team(@user, @group)
#         Scorecard.create_user_scorecard(@user, @group)    
#         GroupsMarkers.join_marker(@group, @group.marker)    
#         
#         @group.accepts_role 'manager', @user
#         @group.accepts_role 'creator', @user
#         @group.accepts_role 'member', @user
#   
#         flash[:notice] = "#{@group.name} #{t(:created)}"
#         redirect_to :action => 'show', :id => @group
#       else
#           render :action => 'new'
#       end  
#     end
#   
#     def set_team
#       session[:group_id] = Group.find(params[:id].to_i)    
#   
#       if !session[:group_id].nil?
#         redirect_to(:controller => 'home', :action => 'index')
#       else
#         index
#       end
#     end  
#   
#     def edit
#       begin    
#         @group = Group.find(params[:id].to_i) 
#         # editing is limited to the manager, creator, administrator
#         permit "manager of :group or creator of :group or maximo", :group => @group do
#           # @users = @group.users
#           # render :template => '/group/form'
#         end
#   
#       rescue ActiveRecord::RecordInvalid
#         flash[:notice] = "#{t(:record_not_found)}"
#         redirect_back_or_default('/')
#       rescue
#         flash[:notice] = "#{t(:something_wrong)}"
#         redirect_back_or_default('/')
#       end
#     end
#   
#     def update
#       begin  
#         @group = Group.find(params[:id].to_i)      
#         # updating is limited to the manager, creator, maximo
#         permit "manager of :group or creator of :group or maximo", :group => @group do
#   
#           if @group.update_attributes(params[:group])  
#             
#             ## recalculate group scorecard 
#             Scorecard.recalculate_group_scorecard(@group)
#                
#             redirect_to :action => 'index'
#           else
#             render :action => 'edit'
#           end
#         end
#   
#       rescue ActiveRecord::RecordInvalid
#         flash[:notice] = "#{t(:record_not_found)}"
#         redirect_back_or_default('/')
#       rescue
#         flash[:notice] = "#{t(:something_wrong)}"
#         redirect_back_or_default('/')
#       end
#     end
  

  
#     def leave_team  
#       @group = Group.find(params[:id].to_i) 
#       # deleting is limited to maximo
#       permit "member of :group", :group => @group do      
#         #      @group = GroupsUsers.find_by_group_id(params[:id])                
#         #      @group.destroy    
#         flash[:notice] = "#{t(:group)} #{t(:deleted)}"
#         redirect_to :action => 'index'
#       end
#     end
#   
#     def destroy  
#       @group = Group.find(params[:id].to_i) 
#       # deleting is limited to administrator
#       permit "manager of :group or maximo", :group => @group do      
#         # @group = Group.find(params[:id].to_i)                
#         # @group.destroy    
#         flash[:notice] = "#{t(:group)} #{t(:deleted)}"
#         redirect_to :action => 'index'
#       end
#     end
  end
