class RatingsController < ApplicationController
  before_filter :get_class_by_name
  before_filter :require_user

  def rate
    # return unless current_user?

    rateable = @rateable_class.find(params[:id])

    # Delete the old ratings for current user
    Rating.delete_all(["rateable_type = ? AND rateable_id = ? AND user_id = ?", 
        @rateable_class.base_class.to_s, params[:id], current_user.id])
        
    # @rating = Rating.new(:rating => params[:rating], :user_id => current_user.id, 
    #                      :rateable_type => params[:type], :rateable_id => params[:id])
    # @rating.save!
    rateable.add_ratings Rating.new(:rating => params[:rating], :user_id => current_user.id)

    # render :update do |page|
    # page.replace_html 'star-ratings-block-#{rateable.id}', :partial => 'rate', :locals => { :asset => rateable }
    # page.visual_effect :highlight, 'star-ratings-block-#{rateable.id}'
    # end
    redirect_back_or_default('index')
  end

  protected

  # Gets the rateable class based on the params[:rateable_type]
  def get_class_by_name
    bad_class = false
    begin
      @rateable_class = Module.const_get(params[:type])
    rescue NameError
      # The user is messing with the content_class…
      bad_class = true
    end

    # This means the user is doing something funky…naughty naughty…
    if bad_class
      redirect_to home_url
      return false
    end

    true
  end

end