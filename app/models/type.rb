# TABLE "types"
# t.string   "name"       
# t.string   "table_type" 
# t.integer  "table_id"
# t.datetime "created_at"
# t.datetime "updated_at"

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

  def self.holiday_type
    find.where("table_type = 'Holiday'").order("id").collect {|p| [p.name, p.id ] }
  end

  def self.default_holiday_type
    find.where("name = 'Local' and table_type = 'Holiday'").first()
  end

end
