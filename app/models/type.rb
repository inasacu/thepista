# == Schema Information
#
# Table name: types
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  table_type :string(40)
#  table_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Type < ActiveRecord::Base

	has_many        :matches
	has_many        :timetables
	has_many        :holidays

	# validations 
	validates_uniqueness_of   :name
	validates_presence_of     :name,          :within => NAME_RANGE_LENGTH

	attr_accessible :name, :table_type

	def self.match_type
		find.where("table_type = 'Match'").order("id").collect {|p| [I18n.t(p.name), p.id ] }
	end

	def self.timetable_type
		find.where("table_type = 'Timetable'").order("id").collect {|p| [I18n.t(p.name), p.id ] }
	end
	
	def self.timetable_type_weekdays
		return find(:all, :conditions => ["table_type = 'Timetable'"], :order => "types.id").collect {|p| [ I18n.t(p.name.downcase), p.id ] }
	end
	
	def self.holiday_type
		find.where("table_type = 'Holiday'").order("id").collect {|p| [p.name, p.id ] }
	end

	def self.default_holiday_type
		find.where("name = 'Local' and table_type = 'Holiday'").first()
	end

	def self.group_type	
		return find(:all, :conditions => ["table_type = 'Group'"], 
											:order => "id").collect {|type| [ get_the_label(type.name), type.id ] }
	end

	def self.venue_type
		return find(:all, :conditions => ["table_type = 'Venue'"], 
											:order => "id").collect {|type| [ get_the_label(type.name), type.id ] }
	end
	
	def self.get_the_label(the_label)		
		return I18n.t("type_#{the_label.downcase}")
	end

end
