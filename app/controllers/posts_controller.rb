class PostsController < ApplicationController
  before_filter :require_user

    def create
    @posts = Post.new(params[:posts])
    @posts.save!
      # flash[:notice] = I18n.t(:successful_create)
      redirect_to @posts.topic.forum
    # else
    #   render :action => 'new'
    # end
  end
end

