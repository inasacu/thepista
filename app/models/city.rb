# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  state_id   :integer          default(1)
#  archive    :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class City < ActiveRecord::Base
  
    belongs_to    :state
    has_many      :users
    has_many      :groups
    has_many      :schedules
    has_many      :venues
    has_many      :holidays

    def self.city_name
      find(:all, :select => "cities.id, cities.name as city_name, states.name as state_name", 
           :joins => "left join states on states.id = cities.state_id", 
           :order => "cities.name").collect {|p| [ "#{p.city_name} #{'('+p.state_name.capitalize+')' if p.city_name != p.state_name}", p.id ] }
    end

end
