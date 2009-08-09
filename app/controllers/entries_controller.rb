class EntriesController < ApplicationController
  
  def show
    @blog = Blog.find(params[:blog_id])
    @user = @blog.user unless @blog.user.nil?
    @group = @blog.group unless @blog.group.nil?
    @entry = @blog.entries.first
    @comments = Comment.find(:all, 
                      :conditions => ["entry_id = ? and created_at > ?",  @entry.id, User::TIME_AGO_FOR_MOSTLY_ACTIVE], 
                      :order => 'created_at DESC')
  end

  def new
    @entry = Entry.new
    @comment = Comment.new
  end
  
  def create
    @blog = Blog.find(params[:id])
    @entry = @blog.entries.first
    
    @comment = Comment.new(:body => params[:comment][:body], :entry_id => @entry.id, :user_id => current_user.id)
    @comment.save!
    
    flash[:notice] = t(:comment_saved)
    redirect_to :action => 'index', :blog_id => @blog.id
    return 
  rescue ActiveRecord::RecordInvalid  
    flash[:error] = t(:comment_not_saved)
    render :action => 'new'
  end
end
