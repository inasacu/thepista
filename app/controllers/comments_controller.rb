class CommentsController < ApplicationController
  before_filter :require_user

  before_filter :get_blog, :get_forum, :has_member_access

  def create
    if @blog
      @blog = Blog.find(params[:blog][:id])

      @comment = Comment.new(params[:comment])
      @blog.comments.create(:body => @comment.body, :user => current_user, :title => @comment.title)     
      redirect_to blog_url(@blog)
      return
    end
    
    if @forum
      @comment = Comment.new(params[:comment])
      @forum.comments.create(:body => @comment.body, :user => current_user, :title => @comment.title)    
      redirect_to forum_url(@forum)
      return
    end
    redirect_to root_url
  end

  private

  def get_blog
    unless params[:blog][:id].blank?
      @blog = Blog.find(params[:blog][:id])
    end
  end

  def get_forum
    unless params[:forum][:id].blank?
      @forum = Forum.find(params[:forum][:id])
    end
  end

  def has_member_access
    # blog comment
    if @blog
      unless @blog.user.blank?
        unless current_user.is_user_member_of?(@blog.user)
          redirect_to root_url
          return
        end
      end

      unless @blog.group.blank?
        unless current_user.is_member_of?(@blog.group)
          redirect_to root_url
          return
        end
      end    

    end
    
    # forum comment
    if @forum
      unless @forum.schedule.blank?
        unless current_user.is_member_of?(@forum.schedule.group)
          redirect_to root_url
          return
        end
      end    

    end
  end
  
end
