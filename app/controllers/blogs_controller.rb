class BlogsController < ApplicationController
  before_filter :require_user

  before_filter :get_blog, :has_member_access

  def show
    @blog = Blog.find(params[:id]) 
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
      has_access = false

      case @blog.item_type
      when "User"
        has_access = current_user.is_user_member_of?(@blog.item)
      when "Group", "Challenge"
        has_access = current_user.is_member_of?(@blog.item)
      when "Venue"
        has_access = true
      end

      unless has_access 
        redirect_to root_url
        return
      end
    end
  end

end
