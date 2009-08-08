class ForumsController < ApplicationController
  def index
    @forums = Forums.all
  end
  
  def show
    @forums = Forums.find(params[:id])
  end
  
  def new
    @forums = Forums.new
  end
  
  def create
    @forums = Forums.new(params[:forums])
    if @forums.save
      flash[:notice] = "Successfully created forums."
      redirect_to @forums
    else
      render :action => 'new'
    end
  end
  
  def edit
    @forums = Forums.find(params[:id])
  end
  
  def update
    @forums = Forums.find(params[:id])
    if @forums.update_attributes(params[:forums])
      flash[:notice] = "Successfully updated forums."
      redirect_to @forums
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @forums = Forums.find(params[:id])
    @forums.destroy
    flash[:notice] = "Successfully destroyed forums."
    redirect_to forums_url
  end
end
