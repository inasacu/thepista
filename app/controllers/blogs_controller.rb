class BlogsController < ApplicationController
  before_filter :require_user

  def show
    redirect_to :controller => 'entries', :action => 'show', :blog_id => params[:id]     
  end
  
end
