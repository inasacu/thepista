class ScorecardsController < ApplicationController
  before_filter :require_user

  def index
		redirect_to groups_url
  end
  
  def list
    redirect_to :action => 'index'
    return      
  end

	def show
		@group = Group.find(params[:id])
		@scorecards = Scorecard.users_group_scorecard(@group, sort_order(''))    
		@schedule = @group.schedules.first
		
		@the_roster_infringe = @schedule.the_roster_infringe
		@the_roster_last_minute_infringe = @schedule.the_last_minute_infringe
		@the_last_played = @schedule.the_roster_last_played
		@the_roster_reputation = @schedule.the_roster_reputation(@group)
		
		
		if @scorecards.nil?	
			redirect_to root_url 
			return
		end
		render @the_template
	end  

  def archive
    @group = Group.find(params[:id])

    @scorecards = Scorecard.where("group_id = ?", @group.id)
    @scorecards.each do |scorecard|
      scorecard.archive = true
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

