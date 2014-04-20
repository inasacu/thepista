class EventComment < ActiveRecord::Base
  attr_accessible :date, :message, :schedule_id, :user_id

  validates_presence_of	:message, :user_id, :schedule_id
  belongs_to	:user

end
