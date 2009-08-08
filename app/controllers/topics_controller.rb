class TopicsController < ApplicationController
  def index
    @topics = Topics.all
  end
  
  def show
    @topics = Topics.find(params[:id])
  end
  
  def new
    @topics = Topics.new
  end
  
  def create
    @topics = Topics.new(params[:topics])
    if @topics.save
      flash[:notice] = "Successfully created topics."
      redirect_to @topics
    else
      render :action => 'new'
    end
  end
  
  def edit
    @topics = Topics.find(params[:id])
  end
  
  def update
    @topics = Topics.find(params[:id])
    if @topics.update_attributes(params[:topics])
      flash[:notice] = "Successfully updated topics."
      redirect_to @topics
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @topics = Topics.find(params[:id])
    @topics.destroy
    flash[:notice] = "Successfully destroyed topics."
    redirect_to topics_url
  end
end
