class Mobile::EventController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def active_events_by_user
    user_id = params[:user_id]
    events = Schedule.user_active_events(user_id)
    if !events.nil?
      success_response(events)
    else
      error_response("Not possible to get the active events")
    end
  end
  
  def active_events_by_user_groups
    user_id = params[:user_id]
    events = Schedule.active_user_groups_events(user_id)
    if !events.nil?
      success_response(events)
    else
      error_response("Not possible to get the events from your groups")
    end
  end
  
  def event_by_id
    event_id = params[:event_id]
    event = Schedule.get_by_id(event_id)
    success_response(event)
  end
  
  def change_user_event_state
    event_id = params[:event_id]
    user_id = params[:user_id]
    new_state = params[:new_state]
    user_event_data = Match.change_user_match_state(event_id, user_id, new_state)
    if !user_event_data.nil?
      success_response(user_event_data)
    else
      error_response("Not possible to change the user state")
    end
  end
  
  def get_user_event_data
    event_id = params[:event_id]
    user_id = params[:user_id]
    user_event_data = Match.get_user_match_data(event_id, user_id)
    if !user_event_data.nil?
      success_response(user_event_data)
    else
      error_response("Not possible to get the user data")
    end
  end

end