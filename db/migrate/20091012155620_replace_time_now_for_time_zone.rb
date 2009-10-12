class ReplaceTimeNowForTimeZone < ActiveRecord::Migration
  def self.up
     change_column  :matches,    :status_at,     :datetime,       :default => Time.zone.now
  end

  def self.down
     change_column  :matches,    :status_at,     :datetime,       :default => Time.now
  end
end
