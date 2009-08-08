class EntriesController < ApplicationController
  def index
    @entries = Entries.all
  end
  
  def show
    @entries = Entries.find(params[:id])
  end
  
  def new
    @entries = Entries.new
  end
  
  def create
    @entries = Entries.new(params[:entries])
    if @entries.save
      flash[:notice] = "Successfully created entries."
      redirect_to @entries
    else
      render :action => 'new'
    end
  end
  
  def edit
    @entries = Entries.find(params[:id])
  end
  
  def update
    @entries = Entries.find(params[:id])
    if @entries.update_attributes(params[:entries])
      flash[:notice] = "Successfully updated entries."
      redirect_to @entries
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @entries = Entries.find(params[:id])
    @entries.destroy
    flash[:notice] = "Successfully destroyed entries."
    redirect_to entries_url
  end
end
