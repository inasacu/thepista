class AddMatchFields < ActiveRecord::Migration
  def self.up
    add_column         :matches,         :position_id,        :integer
    add_column         :matches,         :technical,          :integer,            :default => 0
    add_column         :matches,         :physical,           :integer,            :default => 0
    change_column      :matches,         :description,        :text,               :default => " "
    
    [[49,'defense','User'], [50,'center','User'], [51,'attack','User']].each do |type|
         Type.create(:id => type[0], :name => type[1], :table_type => type[2])
     end
    @matches = Match.find(:all, :conditions => "description is null")
    @matches.each do |match|
      match.update_attributes('description' => '...')
    end
  end

  def self.down
    remove_column         :matches,         :position_id
    remove_column         :matches,         :technical
    remove_column         :matches,         :physical
    change_column         :matches,         :description,        :text
  end
end
