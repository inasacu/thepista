class Mobile::UtilController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def get_cities
    cities = City.get_all
    if !cities.nil?
      success_response(cities)
    else
      error_response("Not possible to get the cities")
    end
  end

  def get_sports
  	sports = Sport.get_all
  	if !sports.nil?
      success_response(sports)
    else
      error_response("Not possible to get the sports")
    end
  end

end