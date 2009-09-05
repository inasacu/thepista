class PracticeAttendees < ActiveRecord::Base
# == Schema Information
# Schema version: 20080916002106
#
# Table name: practice_attendees
#
#  id             :integer(4)      not null, primary key
#  user_id        :integer(4)      
#  practice_id    :integer(4)      
#

  include ActivityLogger

  belongs_to :user
  belongs_to :practice, :counter_cache => true
  validates_uniqueness_of :user_id, :scope => :practice_id

  # after_create :log_activity
  # 
  # def log_activity
  #   add_activities(:item => self, :user => self.user)
  # end

end

