class EntriesController < ApplicationController
  before_filter :require_user
  
  def show
    @blog = Blog.find(params[:blog_id])
    @user = @blog.user unless @blog.user.nil?
    @group = @blog.group unless @blog.group.nil?
    @entry = @blog.entries.first
    @comments = Comment.find(:all, 
                      :conditions => ["entry_id = ? and created_at > ?",  @entry.id, TIME_AGO_FOR_MOSTLY_ACTIVE], 
                      :order => 'created_at DESC')
  end
end
