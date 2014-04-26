class Mobile::VenueM

	attr_accessor :legacy_id, :name, :sports, :latitude, :longitude, 
				  :number_of_events, :address, :city, :region

	def initialize(marker=nil)
	    if !marker.nil?

	      @legacy_id = marker.id
	      @name = marker.name
	      @latitude = marker.latitude
	      @longitude = marker.longitude
	      @address = marker.address
	      @city = marker.city

	      @sports = Array.new
	      if marker.groups
	      	groups = marker.groups
	      	groups.each do |g|
	      		@sport = {:id => g.sport.id, :name => g.sport.name}
	      		@sports << @sport if !@sports.include? @sport
	      	end
	      end

	      @number_of_events = 0
	      if marker.schedules
	      	@number_of_events = marker.schedules.where("starts_at>=?", Time.now).count
	      	#@number_of_events = marker.schedules.count
	      end
	      
	    end
	end

	def self.build_from_markers(markers)
	    venue_array = Array.new
	    markers.each do |marker|
	      venue = Mobile::VenueM.new(marker)
	      venue_array << venue
	    end
	    return venue_array
	  end 

	def self.get_info(marker_id)
		begin
		  marker = Marker.find(marker_id)
		  venue = Mobile::VenueM.new(marker)
		rescue Exception => exc
		  Rails.logger.error("Exception while getting info from venue #{exc.message}")
		  Rails.logger.error("#{exc.backtrace}")
		  venue = nil
		end
		return venue
	end
    
	def self.starred
		begin
		  starred = Marker.limit(5)
		  venues = Mobile::VenueM.build_from_markers(starred)
		rescue Exception => exc
		  Rails.logger.error("Exception while getting info starred venues #{exc.message}")
		  Rails.logger.error("#{exc.backtrace}")
		  venues = nil
		end
		return venues
	end

	def self.active_events(marker_id)
		begin
		  marker = Marker.find(marker_id)
		  schedules = marker.schedules.where("starts_at >= ? and marker_id = ?", Time.zone.now, marker_id)
		  events = Mobile::EventM.build_from_schedules(schedules)
		rescue Exception => exc
		  Rails.logger.error("Exception while getting events from venue #{exc.message}")
		  Rails.logger.error("#{exc.backtrace}")
		  events = nil
		end
		return events
	end
  
end