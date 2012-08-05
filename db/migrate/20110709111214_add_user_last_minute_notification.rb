class AddUserLastMinuteNotification < ActiveRecord::Migration
  def self.up
    add_column		:users,		:last_minute_notification,		:boolean,   :default => true
  end

  def self.down
  end
end
