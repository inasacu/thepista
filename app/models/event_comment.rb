# == Schema Information
#
# Table name: event_comments
#
#  id          :integer          not null, primary key
#  message     :string(255)
#  user_id     :integer
#  schedule_id :integer
#  date        :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EventComment < ActiveRecord::Base
  attr_accessible :date, :message, :schedule_id, :user_id

  validates_presence_of	:message, :user_id, :schedule_id
  belongs_to	:user

end
