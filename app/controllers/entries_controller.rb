class EntriesController < ApplicationController
  before_filter :require_user
  
  def show
    @blog = Blog.find(params[:blog_id])
    @user = @blog.user unless @blog.user.nil?
    @group = @blog.group unless @blog.group.nil?
    @entry = @blog.entries.first
    @comments = Comment.get_latest_comments(@entry)
  end
end
