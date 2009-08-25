class ScorecardsController < ApplicationController
  before_filter :require_user
  
  def index
    # @scorecards = Scorecard.paginate(:per_page => 10, :page => params[:page])
      @groups = current_user.groups
  end
  
  def show
    @group = Group.find(params[:id])
  end

  # def list
  #   @groups = Group.find(:all, :conditions => ['id not in (?)', current_user.groups])
  #   render :template => '/scorecards/index'   
  # end
end

