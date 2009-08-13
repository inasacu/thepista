class HomeController < ApplicationController  
  # before_filter :require_user, :except => [:about, :help, :welcome]

  def index
    
    if current_user
      # @feed = current_user.activities
      # @users = current_user.find_mates
      
    end    
    respond_to do |format|
      format.html
      format.atom
    end  
  end
end
