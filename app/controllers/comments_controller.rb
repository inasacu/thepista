class CommentsController < ApplicationController
  before_filter :require_user

    def create
    @comments = Comment.new(params[:comments])
    @comments.save!
      # flash[:notice] = I18n.t(:successful_create)
      redirect_to @comments.entry.blog
    # else
    #   render :action => 'new'
    # end
  end
end
