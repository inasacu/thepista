class ForumsController < ApplicationController
  before_filter :require_user

  before_filter :get_forum, :has_member_access

  def show
    @forum = Forum.find(params[:id])

    unless @forum.schedule.nil?
      @schedule = @forum.schedule 
      @group = @schedule.group
      @previous = Schedule.previous(@schedule)
      @next = Schedule.next(@schedule)
    end  

    unless @forum.meet.nil?
      @meet = @forum.meet 
      @round = @meet.round
      @previous = Meet.previous(@meet)
      @next = Meet.next(@meet)
    end
    @comments = @forum.comments.recent.limit(COMMENTS_PER_PAGE).all  
  end


  private

  def get_forum
    unless params[:id].blank?
      @forum = Forum.find(params[:id])
    end
  end

  def has_member_access
    # forum comment
    if @forum
      unless @forum.schedule.blank?
        unless current_user.is_member_of?(@forum.schedule.group)
          redirect_to root_url
          return
        end
      end    

      unless @forum.meet.blank?
        unless current_user.is_tour_member_of?(@forum.meet.tournament)
          redirect_to root_url
          return
        end
      end

    end
  end

end

