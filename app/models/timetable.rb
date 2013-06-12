# == Schema Information
#
# Table name: timetables
#
#  id              :integer          not null, primary key
#  day_of_week     :string(255)
#  installation_id :integer
#  type_id         :integer
#  starts_at       :datetime
#  ends_at         :datetime
#  timeframe       :float            default(1.0)
#  archive         :boolean          default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#  item_id         :integer
#  item_type       :string(255)
#

class Timetable < ActiveRecord::Base
	belongs_to    :installation
	belongs_to    :type 
	belongs_to    :item,          		:polymorphic => true

	validates_presence_of     :type_id
	validates_presence_of     :starts_at
	validates_presence_of     :ends_at
	validates_presence_of     :timeframe

	# variables to access
	attr_accessible :installation_id, :type_id, :starts_at, :ends_at, :timeframe, :item_id, :item_type

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
	
	#################### item source code #########################
	

	def self.item_timetable(item)
		self.where("item_id = ? and item_type = ?", item.id, item.class.to_s).order("type_id, starts_at")
	end

	def self.get_items_timetable(item)
		self.where("item_id = ? and item_type = ?", item.id, item.class.to_s).order("type_id, starts_at")
	end

	def self.item_week_day(item, current_day, is_holiday=false)
		the_day_of_week = 'Holiday'
		the_day_of_week = Date::DAYNAMES[current_day.wday] unless is_holiday

		self.where("timetables.archive = false and item_id = ? and item_type = ? and types.table_type = 'Timetable' and types.name =  ?", item.id, item.class.to_s, the_day_of_week).select("timetables.starts_at, timetables.ends_at, timetables.timeframe").joins("join types on types.id = timetables.type_id").order("timetables.type_id, timetables.starts_at")
	end	

	# def self.branch_min_max_timetable(company)
	# 	self.where("branch.company_id = ?", company).select("min(timetables.starts_at) as starts_at, max(timetables.ends_at) as ends_at").joins("LEFT JOIN branches on branches.id = timetables.item_id").first()
	# end  		
	
	# WIDGET PROJECT ----------------------------
	
	def self.branch_week_timetables(branch)
	  self.joins("join groups on groups.id=timetables.item_id")
        .where("groups.item_id=?", branch.id)
	      .where("timetables.starts_at=? and timetables.ends_at=?", Date.today, Date.today+7)
	end
  
end


