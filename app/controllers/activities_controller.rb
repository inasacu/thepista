class ActivitiesController < ApplicationController

  before_filter :authorize_user, :only => :destroy

  # This gets called after activity destruction for some reason.
  def show
    render :text => ""
  end

  # DELETE /activities/1
  # DELETE /activities/1.xml
  def destroy
    @activity.destroy
    flash[:success] = "Activity deleted"

    respond_to do |format|
      format.html { redirect_to(user_url(current_user)) }
      format.xml  { head :ok }
    end
  end

  private

    def authorize_user
      @activity = Activity.find(params[:id])
      unless current_user == @activity.user
        redirect_to home_url
      end
    end

end