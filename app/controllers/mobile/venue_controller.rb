class Mobile::VenueController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def starred_venues
    starred = Mobile::VenueM.starred
    if !starred.nil?
    	success_response(starred)
    else
    	error_response("Not possible to get the starred venues")
    end
  end

  def get_info
  	venue_id = params[:venue_id]
  	venue = Mobile::VenueM.get_info(venue_id)
    if !venue.nil?
    	success_response(venue)
    else
    	error_response("Not possible to get the info of the venue")
    end
  end

  def venue_events
  	venue_id = params[:venue_id]
  	events = Mobile::VenueM.active_events(venue_id)
    if !events.nil?
    	success_response(events)
    else
    	error_response("Not possible to get the venue events")
    end
  end

end