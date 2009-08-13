class PostsController < ApplicationController
  before_filter :require_user
  
  def index
    @posts = Post.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @posts = Post.find(params[:id])
  end
  
  def new
    @posts = Post.new
  end
  
  def create
    @posts = Post.new(params[:posts])
    if @posts.save
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @posts
    else
      render :action => 'new'
    end
  end
  
  def edit
    @posts = Post.find(params[:id])
  end
  
  def update
    @posts = Post.find(params[:id])
    if @posts.update_attributes(params[:posts])
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @posts
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @posts = Post.find(params[:id])
    @posts.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to posts_url
  end
end

