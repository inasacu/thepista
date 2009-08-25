class ScorecardsController < ApplicationController
  before_filter :require_user
  
  def index
    # @scorecards = Scorecard.paginate(:per_page => 10, :page => params[:page])
      @groups = current_user.groups
  end
  
  # def show
  #   @scorecards = Scorecard.paginate(params[:id], :per_page => 10, :page => params[:page])
  # end

  # def list
  #   @groups = Group.find(:all, :conditions => ['id not in (?)', current_user.groups])
  #   render :template => '/scorecards/index'   
  # end
end

