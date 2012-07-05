# TABLE "timetables"
# t.string   "day_of_week"
# t.integer  "installation_id"
# t.integer  "type_id"
# t.datetime "starts_at"
# t.datetime "s_at"
# t.float    "timeframe"       
# t.boolean  "archive"         
# t.datetime "created_at"
# t.datetime "updated_at"

class Timetable < ActiveRecord::Base
	belongs_to    :installation
	belongs_to    :type 

	validates_presence_of     :installation_id
	validates_presence_of     :type_id
	validates_presence_of     :starts_at
	validates_presence_of     :ends_at
	validates_presence_of     :timeframe

	# validates_uniqueness_of   :installation_id, :type_id, :starts_at, :ends_at, :timeframe

	# variables to access
	attr_accessible :installation_id, :type_id, :starts_at, :ends_at, :timeframe

	def day_of_week
		I18n.t(self.type.name.capitalize)
	end

	def self.installation_timetable(installation)
		self.where("installation_id = ?", installation).order("type_id, starts_at")
	end

	def self.get_installations_timetable(installation)
		self.where("installation_id = ?", installation)
	end

	def self.installation_week_day(installation, current_day, is_holiday=false)
		the_day_of_week = 'Holiday'
		the_day_of_week = Date::DAYNAMES[current_day.wday] unless is_holiday

		self.where("timetables.archive = false and installation_id = ? and types.table_type = 'Timetable' and types.name =  ?", installation.id, the_day_of_week).select("timetables.starts_at, timetables.ends_at, timetables.timeframe").joins("join types on types.id = timetables.type_id").order("timetables.type_id, timetables.starts_at")
	end	

	def self.venue_min_max_timetable(venue)
		self.where("installations.venue_id = ?", venue).select("min(timetables.starts_at) as starts_at, max(timetables.ends_at) as ends_at").joins("LEFT JOIN installations on installations.id = timetables.installation_id").first()
	end   		

end


