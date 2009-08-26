class CommentsController < ApplicationController
  before_filter :require_user

  def create
    @comments = Comment.new(params[:comments])
    @comments.save!
    redirect_to @comments.entry.blog
  end
end
