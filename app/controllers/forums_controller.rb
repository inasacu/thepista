class ForumsController < ApplicationController
  before_filter :require_user

  def show
    redirect_to :controller => 'topics', :action => 'show', :forum_id => params[:id]
  end  
end
