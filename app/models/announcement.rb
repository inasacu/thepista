# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  message    :text
#  starts_at  :datetime
#  ends_at    :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Announcement < ActiveRecord::Base
  
  # named_scope :active, lambda { { :conditions => ['starts_at <= ? and ends_at >= ?', Time.zone.now, Time.zone.now] } }
  # named_scope :since, lambda { |hide_time| { :conditions => (hide_time ? ['updated_at > ? or starts_at > ?', Time.zone.now, Time.zone.now] : nil) } }
  def self.current_announcements(hide_time)
    active.since(hide_time)
  end
    
  def self.previous_announcement(page = 1)
    self.where("starts_at <= ? and ends_at < ?", Time.zone.now, Time.zone.now).page(page).order('starts_at')
  end

  private 

  def validate
    self.errors.add(:starts_at, I18n.t(:must_be_before_ends_at)) if self.starts_at >= self.ends_at
    self.errors.add(:ends_at, I18n.t(:must_be_after_starts_at)) if self.ends_at <= self.starts_at
  end
end
