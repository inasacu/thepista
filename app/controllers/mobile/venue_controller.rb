class Mobile::VenueController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def starred_venues
    starred = Venue.starred
    if !starred.nil?
    	success_response(starred)
    else
    	error_response("Not possible to get the starred venues")
    end
  end

end