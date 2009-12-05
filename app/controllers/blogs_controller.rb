class BlogsController < ApplicationController
  before_filter :require_user

  def show
    @user = Blog.find(params[:id]).user
    unless current_user.is_user_member_of?(@user) 
      redirect_to root_url
      return
    end
    redirect_to :controller => 'entries', :action => 'show', :blog_id => params[:id]     
  end
  
end
