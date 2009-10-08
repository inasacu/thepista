class ScorecardsController < ApplicationController
  before_filter :require_user
  
  def index
    @groups = current_user.groups.paginate :page => params[:page], :order => 'name'
    
    # @scorecards = Scorecard.find(:all, 
    #           :joins => "LEFT JOIN users on users.id = scorecards.user_id",
    #           :conditions => ["group_id in (?) and user_id > 0 and played > 0 and scorecards.archive = false", current_user.groups],
    #           :order => "group_id, points DESC, ranking, users.name")
    # @scorecards = Scorecard.paginate(:all, 
    # :conditions => ["group_id in (?) and user_id > 0 and played > 0 and archive = false", current_user.groups],
    # :order => "group_id, points DESC, ranking",
    # :per_page => 10, :page => params[:page])
  end
  
  def list
    @scorecards = Scorecard.find(:all, 
                    :conditions => ["group_id in (?) and user_id = 0 and scorecards.archive = true and season_ends_at < ?", 
                                    current_user.groups, Time.now])
    @groups = Group.paginate(:all, :conditions => ["id in (?)", @scorecards],:per_page => 10, :page => params[:page])   
    
    # @scorecards = Scorecard.find(:all, 
    #       :joins => "LEFT JOIN users on users.id = scorecards.user_id",
    #       :conditions => ["group_id in (?) and user_id > 0 and played > 0 and scorecards.archive = true and season_ends_at < ?", current_user.groups, Time.now],
    #       :order => "group_id, points DESC, ranking, users.name")

    # @scorecards = Scorecard.paginate(:all, 
    #       :conditions => ["group_id in (?) and user_id > 0 and played > 0 and archive = true and season_ends_at < ?", current_user.groups, Time.now],
    #       :order => "group_id, points DESC, ranking",
    #       :per_page => 10, :page => params[:page])   
    @archive = true
    render :template => '/scorecards/index' 
  end
  
  def show
    @group = Group.find(params[:id])
    @scorecards = Scorecard.users_group_scorecard(@group)
    
    # @scorecards = @group.scorecards
    # @scorecards = Scorecard.find(:all, 
    #            :joins => "LEFT JOIN users on users.id = scorecards.user_id",
    #            :conditions => ["group_id in (?) and user_id > 0 and played > 0 and scorecards.archive = false", @group],
    #            :order => "group_id, points DESC, ranking, users.name")
    # @scorecards = @group.scorecards.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show_archive
    @group = Group.find(params[:id])
    @scorecards = Scorecard.find(:all, 
          :joins => "LEFT JOIN users on users.id = scorecards.user_id",
          :conditions => ["group_id in (?) and user_id > 0 and played > 0 and scorecards.archive = true and season_ends_at < ?", @group, Time.now],
          :order => "group_id, points DESC, ranking, users.name")

    # @scorecards = Scorecard.paginate(:all, 
    # :conditions => ["group_id in (?) and user_id > 0 and played > 0 and archive = true and season_ends_at < ?", @group, Time.now],
    # :order => "group_id, points DESC, ranking",
    # :per_page => 10, :page => params[:page])
          
    @archive = true
    render :template => '/scorecards/show'
  end

  def archive
    @group = Group.find(params[:id])
    
    @scorecards = Scorecard.find(:all, :conditions => ["group_id = ?", @group.id])
    @scorecards.each do |scorecard|
      scorecard.archive = true
      scorecard.season_ends_at = Time.utc(Time.now.year, 8, 1) # set end of season to 1 august current.year
      scorecard.save!
    end

    # group scorecards for previous season were archive so create new ones
    Scorecard.create_group_scorecard(@group)
    @group.users.each do |user|
      Scorecard.create_user_scorecard(user, @group)
    end
    redirect_to :action => 'index'
  end
    
  # def list
  #   @groups = Group.find(:all, :conditions => ['id not in (?)', current_user.groups])
  #   render :template => '/scorecards/index'   
  # end
  
end

