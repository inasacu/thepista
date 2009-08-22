class TopicsController < ApplicationController
  before_filter :require_user
  
  def show
    @forum = Forum.find(params[:forum_id])
    @schedule = @forum.schedule unless @forum.schedule.nil?
    @group = @schedule.group
    # @group = @forum.group unless @forum.group.nil?
    @topic = @forum.topics.first
    @posts = Post.find(:all, 
                      :conditions => ["topic_id = ? and created_at > ?",  @topic.id, TIME_AGO_FOR_MOSTLY_ACTIVE], 
                      :order => 'created_at DESC')
  end
end
