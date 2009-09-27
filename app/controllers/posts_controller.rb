class PostsController < ApplicationController
  before_filter :require_user

  def create
    @posts = Post.new(params[:posts])
    @posts.save!
    redirect_to @posts.topic.forum
  end
end