class ForumsController < ApplicationController
  def index
    @forums = Forum.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @forums = Forum.find(params[:id])
  end
  
  def new
    @forums = Forum.new
  end
  
  def create
    @forums = Forum.new(params[:forums])
    if @forums.save
      flash[:notice] = "Successfully created forums."
      redirect_to @forums
    else
      render :action => 'new'
    end
  end
  
  def edit
    @forums = Forum.find(params[:id])
  end
  
  def update
    @forums = Forum.find(params[:id])
    if @forums.update_attributes(params[:forums])
      flash[:notice] = "Successfully updated forums."
      redirect_to @forums
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @forums = Forum.find(params[:id])
    @forums.destroy
    flash[:notice] = "Successfully destroyed forums."
    redirect_to forums_url
  end
end
