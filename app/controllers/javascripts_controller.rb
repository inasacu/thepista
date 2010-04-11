class JavascriptsController < ApplicationController

  def hide_announcements
    time = Time.zone.now
    set_session time
    set_cookies time
    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.js { redirect_to(root_path) }
    end
  end

  private
    def set_session(time)
      session[:announcement_hide_time] = time
    end
    #TODO change expiration time to be the expiration 
    #date from the list in current_announcements
    def set_cookies(time)
      cookies[:announcement_hide_time] = {
        :value => time.to_datetime.to_s,
        :expires => time.next_week
      }
    end
end
