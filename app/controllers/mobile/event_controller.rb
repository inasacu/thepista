class Mobile::EventController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def active_events_by_user
    user_id = params[:user_id]
    events = Mobile::EventM.user_active_events(user_id)
    if !events.nil?
      success_response(events)
    else
      error_response("Not possible to get the active events")
    end
  end
  
  def active_events_by_user_groups
    user_id = params[:user_id]
    events = Mobile::EventM.active_user_groups_events(user_id)
    if !events.nil?
      success_response(events)
    else
      error_response("Not possible to get the events from your groups")
    end
  end
  
  def event_by_id
    event_id = params[:event_id]
    event = Mobile::EventM.get_by_id(event_id)
    success_response(event)
  end
  
  def change_user_event_state
    event_id = params[:event_id]
    user_id = params[:user_id]
    new_state = params[:new_state]
    user_event_data = Mobile::EventM.change_user_match_state(event_id, user_id, new_state)
    if !user_event_data.nil?
      success_response(user_event_data)
    else
      error_response("Not possible to change the user state")
    end
  end
  
  def get_user_event_data
    event_id = params[:event_id]
    user_id = params[:user_id]
    user_event_data = Mobile::EventM.get_user_match_data(event_id, user_id)
    if !user_event_data.nil?
      success_response(user_event_data)
    else
      error_response("Not possible to get the user data")
    end
  end

  def get_event_info_related_to_user
    event_id = params[:event_id]
    user_id = params[:user_id]
    user_event_data = Mobile::EventM.get_info_related_to_user(event_id, user_id)
    if !user_event_data.nil?
      success_response(user_event_data)
    else
      error_response("Not possible to get the event data")
    end
  end

  def create_event
    #temporarily
    new_event = Mobile::EventM.create_new(params)
    if !new_event.nil?
      success_response(new_event)
    else
      error_response("Not possible to create event")
    end
  end

  def edit_event
    #temporarily
    edited_event = Mobile::EventM.edit(params)
    if !edited_event.nil?
      success_response(edited_event)
    else
      error_response("Not possible to edit event")
    end
  end

  def historical_of_events
    offset_factor = params[:offset_factor]
    user_id = params[:user_id]
    event_list = Mobile::EventM.last_user_events(user_id, offset_factor)
    if !event_list.nil?
      success_response(event_list)
    else
      error_response("Not possible to get historical of events")
    end
  end

  def event_search
    start_date = params[:start_date]
    end_date = params[:end_date]
    start_time = params[:start_time]
    venue = params[:venue]
    city = params[:city]
    event_list = Mobile::EventM.do_search(start_date, end_date, start_time, venue, city)
    if !event_list.nil?
      success_response(event_list)
    else
      error_response("Not possible to search events")
    end
  end

  def change_user_event_team
    event_id = params[:event_id]
    user_id = params[:user_id]
    result_map = Mobile::EventM.change_user_team(user_id, event_id)
    if result_map
      success_response(result_map)
    else
      error_response("Not possible to change the user event team")
    end
  end

  def update_event_results
    event_id = params[:event_id]
    total_score = params[:total_score]
    individual_score = params[:individual_score]
    success = Mobile::EventM.update_score(event_id, total_score, individual_score)
    if success
      success_response(success)
    else
      error_response("Not possible to change event results")
    end
  end

  def get_event_teams
    event_id = params[:event_id]
    teams_map = Mobile::EventM.get_teams(event_id)
    if teams_map
      success_response(teams_map)
    else
      error_response("Not possible to get event teams")
    end
  end

  def get_event_results
    event_id = params[:event_id]
    results_map = Mobile::EventM.get_results(event_id)
    if results_map
      success_response(results_map)
    else
      error_response("Not possible to get event results")
    end
  end  

end