class Mobile::UtilController < Mobile::SecurityController
  
  before_filter :check_active_token
  
  def get_cities
    cities = Mobile::UtilM.get_all_cities
    if !cities.nil?
      success_response(cities)
    else
      error_response("Not possible to get the cities")
    end
  end

  def get_sports
  	sports = Mobile::UtilM.get_all_sports
  	if !sports.nil?
      success_response(sports)
    else
      error_response("Not possible to get the sports")
    end
  end

end