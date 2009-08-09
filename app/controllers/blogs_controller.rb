class BlogsController < ApplicationController
  def show
    redirect_to :controller => 'entries', :action => 'show', :blog_id => params[:id]
  end
end
