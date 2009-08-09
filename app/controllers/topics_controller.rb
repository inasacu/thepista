class TopicsController < ApplicationController
  def index
    @topics = Topic.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @topics = Topic.find(params[:id])
  end
  
  def new
    @topics = Topic.new
  end
  
  def create
    @topics = Topic.new(params[:topics])
    if @topics.save
      flash[:notice] = "Successfully created topics."
      redirect_to @topics
    else
      render :action => 'new'
    end
  end
  
  def edit
    @topics = Topic.find(params[:id])
  end
  
  def update
    @topics = Topic.find(params[:id])
    if @topics.update_attributes(params[:topics])
      flash[:notice] = "Successfully updated topics."
      redirect_to @topics
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @topics = Topic.find(params[:id])
    @topics.destroy
    flash[:notice] = "Successfully destroyed topics."
    redirect_to topics_url
  end
end
