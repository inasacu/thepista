class MessagesController < ApplicationController
  def index
    @messages = Messages.all
  end
  
  def show
    @messages = Messages.find(params[:id])
  end
  
  def new
    @messages = Messages.new
  end
  
  def create
    @messages = Messages.new(params[:messages])
    if @messages.save
      flash[:notice] = "Successfully created messages."
      redirect_to @messages
    else
      render :action => 'new'
    end
  end
  
  def edit
    @messages = Messages.find(params[:id])
  end
  
  def update
    @messages = Messages.find(params[:id])
    if @messages.update_attributes(params[:messages])
      flash[:notice] = "Successfully updated messages."
      redirect_to @messages
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @messages = Messages.find(params[:id])
    @messages.destroy
    flash[:notice] = "Successfully destroyed messages."
    redirect_to messages_url
  end
end
