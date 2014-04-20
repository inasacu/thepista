class Mobile::UtilM
  
  def self.get_all_cities
    #Rails.cache.clear
    city_hash = Rails.cache.fetch("cities") do
      self.select([:id, :name]).map { |c| {:id => c.id, :name => c.name} }
    end
    return city_hash
  end

  def self.get_all_sports
    #Rails.cache.clear
    sport_hash = Rails.cache.fetch("sports") do
      self.select([:id, :name]).map { |c| {:id => c.id, :name => c.name} }
    end
    return sport_hash
  end
  
end