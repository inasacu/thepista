class TopicsController < ApplicationController
  before_filter :require_user
  
  def show
    @forum = Forum.find(params[:forum_id])
    @user = @forum.user unless @forum.user.nil?
    @group = @forum.group unless @forum.group.nil?
    @entry = @forum.entries.first
    @posts = Post.find(:all, 
                      :conditions => ["topic_id = ? and created_at > ?",  @entry.id, User::TIME_AGO_FOR_MOSTLY_ACTIVE], 
                      :order => 'created_at DESC')
  end

  def new
    @topic = Topic.new
    @post = Post.new
  end
  
  def create
    @forum = Forum.find(params[:id])
    @topic = @forum.topics.first
    
    @post = Post.new(:body => params[:post][:body], :topic_id => @topic.id, :user_id => current_user.id)
    @post.save!
    
    flash[:notice] = I18n.t(:post_saved)
    redirect_to :action => 'index', :forum_id => @forum.id
    return 
  rescue ActiveRecord::RecordInvalid  
    flash[:error] = I18n.t(:post_not_saved)
    render :action => 'new'
  end
  
end