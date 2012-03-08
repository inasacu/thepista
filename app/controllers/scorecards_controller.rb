class ScorecardsController < ApplicationController
  before_filter :require_user

  def index
    @groups = Group.where("groups.archive = false ").page(params[:page]).order('groups.created_at DESC')
    render @the_template
  end
  
  def list
    redirect_to :action => 'index'
    return      
  end

  def show
    @group = Group.find(params[:id])
    @scorecards = Scorecard.users_group_scorecard(@group, sort_order(''))    
    redirect_to root_url if @scorecards.nil?	
    render @the_template
  end  

  def sort_order(default)
    "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
  end

  # review if this is needed...
  def show_archive
    @group = Group.find(params[:id])
	
	
    @scorecards = Scorecard.find(:all, 
    :joins => "LEFT JOIN users on users.id = scorecards.user_id",
    :conditions => ["group_id in (?) and user_id > 0 and played > 0 and scorecards.archive = true and season_ends_at < ?", @group, Time.zone.now],
    :order => "group_id, points DESC, ranking, users.name")

    @archive = true
    set_the_template('scorecards/show')
    render @the_template
  end

  def archive
    @group = Group.find(params[:id])

    @scorecards = Scorecard.find(:all, :conditions => ["group_id = ?", @group.id])
    @scorecards.each do |scorecard|
      scorecard.archive = true
      scorecard.season_ends_at = Time.utc(Time.zone.now.year, 8, 1) # set end of season to 1 august current.year
      scorecard.save!
    end

    # group scorecards for previous season were archive so create new ones
    Scorecard.create_group_scorecard(@group)
    @group.users.each do |user|
      Scorecard.create_user_scorecard(user, @group)
    end
    redirect_to :action => 'index'
  end

end

