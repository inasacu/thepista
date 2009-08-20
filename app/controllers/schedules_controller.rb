class SchedulesController < ApplicationController
  before_filter :require_user
  before_filter :get_schedule, :only => [:show, :edit, :update, :destroy, :team_roster, :team_no_show]
  before_filter :get_group, :only =>[:new]
  
  def index    
    # only displayed based on date previous to today
    @schedules = Schedule.paginate(:all, 
      :conditions => ["starts_at >= ? and group_id in (select group_id from groups_users where user_id = ?)", Time.now, current_user.id],
      :order => 'group_id, starts_at', :page => params[:page])
  end

  def list    
    #only display based on date after today
    @schedules = Schedule.paginate(:all, 
    :conditions => ["starts_at < ? and group_id in (select group_id from groups_users where user_id = ?)", Time.now, current_user.id],
    :order => 'group_id, starts_at desc', :page => params[:page])
    render :template => '/schedules/index'       
  end

  
  def show
    @schedule = Schedule.find(params[:id])
    @group = @schedule.group
  end
  
  # def show
  #   store_location  
  #   @match = @schedule.matches.first
  #     # @previous = Schedule.previous(@schedule)
  #     # @next = Schedule.next(@schedule)
  # end

  def team_roster  
    store_location  
    @match_type = Type.find(:all, :conditions => "id in (1, 3, 5)")
  end

  def team_no_show  
    store_location
    @match_type = Type.find(:all, :conditions => "id in (1, 3, 5)")
  end
  
#  def show
#    @schedule = Schedule.find(params[:id])
#  end

  def search
    count = Schedule.count_by_solr(params[:search])
    @schedules = Schedule.paginate_all_by_solr(params[:search], :page => params[:page], :total_entries => count, :limit => 25, :offset => 1)

    # @schedules = Schedule.paginate_all_by_solr(params[:search].to_s, :page => params[:page])
    render :template => '/schedules/index'
  end


  def new   
    
    # editing is limited to administrator or creator
    # permit "manager of :group or creator of :group or maximo", :group => @group do 
      @schedule = Schedule.new
      @schedule.group_id = @group.id
      @schedule.sport_id = @group.sport_id
      @schedule.marker_id = @group.marker_id
      @schedule.time_zone = @group.time_zone
      @schedule.jornada = 1

      @lastSchedule = Schedule.find(:first, :conditions => ["id = (select max(id) from schedules where group_id = ?) ", @group.id])    
      if !@lastSchedule.nil?
        @schedule = @lastSchedule 
        @schedule.jornada ||= 0
        @schedule.jornada += 1
        @schedule.starts_at = @lastSchedule.starts_at + 7.days
        @schedule.ends_at = @lastSchedule.ends_at + 7.days
        
        # @schedule.starts_at += @schedule.repeat_every.days
        # @schedule.ends_at += @schedule.repeat_every.days
        
        # @schedule.reminder_at = (@schedule.reminder_at.nul? ? @schedule.starts_at - 2.days : @schedule.reminder_at + @schedule.repeat_every.days)
        # @schedule.subscription_at = (@schedule.subscription_at.equals('') ? @schedule.subscription_at - 2.days :  @schedule.subscription_at + @schedule.repeat_every.days)
        # @schedule.non_subscription_at = (@schedule.non_subscription_at.blank? ? @schedule.starts_at - 2.days :  @schedule.non_subscription_at + @schedule.repeat_every.days)

        @schedule.reminder_at = @lastSchedule.starts_at - 2.days
        @schedule.subscription_at = @lastSchedule.starts_at - 2.days
        @schedule.non_subscription_at = @lastSchedule.starts_at - 1.day

      end
      #render :template => '/schedules/new'
    # end
  end

  def create
    @schedule = Schedule.new(params[:schedule])
    if @schedule.save and @schedule.create_schedule_forum_details(current_user)
      # @schedule.create_schedule_details
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @schedule
    else
      render :action => 'new'
    end
  end

  def edit
    @schedule = current_schedule
  end
  
  # PUT /schedules/1
  # PUT /schedules/1.xml
  def update
    @schedule = current_schedule

    @schedule.attributes = params[:schedule]
    @schedule.save do |result|
      if result
        # flash[:notice] = control_action_label('notice')
        flash[:notice] = I18n.t(:successful_update)
        redirect_to root_url
      else
        render :action => 'edit'
      end
    end
  end

  def edit 
    @schedule = Schedule.find(params[:id])
    # editing is limited to the manager, creator, maximo
    permit "manager of :group or creator of :group or maximo", :group => @schedule.group do
      render :template => '/schedules/edit' 
    end
  end

  def update  
    # updating is limited to the manager, creator, maximo
    permit "manager of :group or creator of :group or maximo", :group => @schedule.group do
      @schedule.attributes = params[:schedule] 
      if @schedule.save
        @schedule.create_schedule_details
        redirect_to :action => 'show', :id => @schedule
        return
      else
        render :template =>  '/layouts/current/edit'
      end
    end 
  end
 
  def edit_match 
    @schedule = Schedule.find(params[:id].to_i)     
    @match = @schedule.matches.first   
    @matches = @schedule.the_roster
  end
  
  def update_match
    @schedule = Schedule.find(params[:id])
    
    @schedule.matches.each do |match|
      match.attributes = params[:match] 
      @schedule.played = (!match.group_score.nil? and !match.invite_score.nil?) 

      match.played = (match.type_id == 1 and @schedule.played)   # compare value to 'Convocado'

      # 1 == team one wins
      # x == teams draw
      # 2 == team two wins
      match.one_x_two = "" if (match.group_score.nil? or match.invite_score.nil?)
      match.one_x_two = "1" if (match.group_score.to_i > match.invite_score.to_i)
      match.one_x_two = "X" if (match.group_score.to_i == match.invite_score.to_i)
      match.one_x_two = "2" if (match.group_score.to_i < match.invite_score.to_i)

      # 1 == player is in team one
      # x == game tied, doesnt matter where player is
      # 2 == player is in team two      
      match.user_x_two = "1" if (match.group_id > 0 and match.invite_id == 0)
      match.user_x_two = "X" if (match.group_score.to_i == match.invite_score.to_i)
      match.user_x_two = "2" if (match.group_id == 0 and match.invite_id > 0)

      match.save!  
      @description = match.description
    end       

    if @schedule.update_attributes(params[:schedule])

      Scorecard.recalculate_group_scorecard(@schedule.group)
      Scorecard.update_group_ranking(@schedule)

      # post details entered by team manager in description
      @post = Post.new(:body => @description, :topic_id => @schedule.forum.topics.first.id, :user_id => current_user.id)
      @post.save!  if @schedule.played?

      flash[:notice] = I18n.t(:scorecard_updated)
      redirect_to schedule_path(@schedule)
    else
      render :action => 'edit'
    end
  end

  def destroy    
    #    @schedule = Schedule.find(params[:id])
    permit "manager of :group or creator of :group or maximo", :group => @schedule.group do      
      # this code is to remove results from scorecard based on this schedule
      @schedule.played = false
      @schedule.save

      @schedule.matches.each do |match|
        match.group_score, match.invite_score = nil, nil
        match.played = false
        match.one_x_two = "" 
        match.user_x_two = "X" 
        match.save! 
        Scorecard.update_user_scorecard(match, @schedule)
      end
                  
      Post.find_by_topic_id(self.forum.topics.first.id).destroy      
      Topic.find_by_forum_id(self.forum.id).destroy
      Forum.find_by_schedule_id(self.id).destroy
      
      @schedule.destroy
      flash.now[:notice] = "#{t :schedule} #{t(:deleted)}"
      redirect_to :action => 'index'  
    end 
  end

  private
  def get_schedule
    @schedule = Schedule.find(params[:id])
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

