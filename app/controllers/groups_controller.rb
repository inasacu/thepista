class GroupsController < ApplicationController
    before_filter :require_user
    
  def index
    @groups = current_user.groups.paginate :page => params[:page], :order => 'name'  
  end
  
  def list
    @groups = Group.paginate(:all, :page => params[:page], :order => 'name')
    render :template => '/groups/index'       
  end
  
  # def list    
  #   @group = Group.find(params[:id])
  #   @users = @group.users
  # end
  
  def team_list
    @group = Group.find(params[:id]) 
    @users = @group.users 
  end
  
  def show
	  store_location 
    @group = Group.find(params[:id])
  end
  
  def new
    @group = Group.new
    @group.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    @markers = Marker.find(:all)
    @sports = Sport.find(:all)
  end
  
  def create
    @group = Group.new(params[:group])		
    @user = current_user
  # @group.description.gsub!(/\r?\n/, "<br>")
  		
    if @group.save and @group.create_group_details(current_user)
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
end