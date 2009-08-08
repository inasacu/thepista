class BlogsController < ApplicationController
  def index
    @blogs = Blogs.all
  end
  
  def show
    @blogs = Blogs.find(params[:id])
  end
  
  def new
    @blogs = Blogs.new
  end
  
  def create
    @blogs = Blogs.new(params[:blogs])
    if @blogs.save
      flash[:notice] = "Successfully created blogs."
      redirect_to @blogs
    else
      render :action => 'new'
    end
  end
  
  def edit
    @blogs = Blogs.find(params[:id])
  end
  
  def update
    @blogs = Blogs.find(params[:id])
    if @blogs.update_attributes(params[:blogs])
      flash[:notice] = "Successfully updated blogs."
      redirect_to @blogs
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @blogs = Blogs.find(params[:id])
    @blogs.destroy
    flash[:notice] = "Successfully destroyed blogs."
    redirect_to blogs_url
  end
end
