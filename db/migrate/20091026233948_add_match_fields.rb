class AddMatchFields < ActiveRecord::Migration
  def self.up    
    add_column         :matches,         :position_id,        :integer,             :detault => @type.id
    add_column         :matches,         :technical,          :integer,             :default => 3
    add_column         :matches,         :physical,           :integer,             :default => 3
    change_column      :matches,         :type_id,            :integer,             :detault => 3        
  end

  def self.down
  end
end
