class Mobile::EventController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def active_events_by_user
    user_id = params[:user_id]
    events = Schedule.user_active_events(user_id)
    success_response(events)
  end
  
  def active_events_by_user_groups
    user_id = params[:user_id]
    events = Schedule.active_user_groups_events(user_id)
    success_response(events)
  end

end