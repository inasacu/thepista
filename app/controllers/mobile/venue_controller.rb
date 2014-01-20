class Mobile::VenueController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def starred_venues
    starred = Venue.starred
    success_response(starred)
  end

end