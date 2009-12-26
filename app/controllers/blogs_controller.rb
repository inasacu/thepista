class BlogsController < ApplicationController
  before_filter :require_user

  before_filter :get_blog, :has_member_access

  def show
    @blog = Blog.find(params[:id]) 
    @user = @blog.user unless @blog.user.nil?
    @group = @blog.group unless @blog.group.nil?
    @tournament = @blog.tournament unless @blog.tournament.nil?

    @comments = @blog.comments.recent.limit(COMMENTS_PER_PAGE).all    
  end

  private

  def get_blog
    unless params[:id].blank?
      @blog = Blog.find(params[:id])
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

      unless @blog.tournament.blank?
        unless current_user.is_tour_member_of?(@blog.tournament)
          redirect_to root_url
          return
        end
      end

    end
  end

end
