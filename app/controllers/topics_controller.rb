class TopicsController < ApplicationController
  before_filter :require_user

  def show
    @forum = Forum.find(params[:forum_id])

    unless @forum.schedule.nil?
      @schedule = @forum.schedule 
      @group = @schedule.group
    end  

    unless @forum.meet.nil?
      @meet = @forum.meet 
      @round = @meet.round
    end
    
    @topic = @forum.topics.first
    @posts = Post.find(:all, 
    :conditions => ["topic_id = ? and created_at > ?",  @topic.id, TIME_AGO_FOR_MOSTLY_ACTIVE], 
    :order => 'created_at DESC')
  end
end
