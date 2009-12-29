class CloudsController < ApplicationController
  before_filter :require_user

  def show    
    @tag = Tagging.find(:first, :select => "taggings.taggable_type", 
                    :joins => "LEFT JOIN tags on tags.id = taggings.tag_id",
                    :conditions => ["tags.name like ?", params[:id]])
                    
    case @tag.taggable_type     
    when "Schedule"
      @schedules = Schedule.tagged_with(params[:id]).paginate(:page => params[:page], :per_page => SCHEDULES_PER_PAGE)
      @clouds = @schedules  
      render :template => '/schedules/index'
      return
    when "Scorecard"
      @scorecards = Scorecard.tagged_with(params[:id]).paginate(:page => params[:page], :per_page => SCHEDULES_PER_PAGE)
      @groups = User.find(@scorecards.first.user_id).groups
      @clouds = @groups 
      render :template => '/scorecards/index' 
      return
    else
      redirect_to root_url

    end

  end

end
