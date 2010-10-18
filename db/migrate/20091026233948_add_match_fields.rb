class AddMatchFields < ActiveRecord::Migration
  def self.up
    # [[17,'defense','User'], [18,'center','User'], [19,'attack','User']].each do |type|
    #   Type.create(:id => type[0], :name => type[1], :table_type => type[2])
    # end

    # @type = Type.find(:first, :conditions => "name = 'center' and table_type = 'User'")
    
    add_column         :matches,         :position_id,        :integer,             :detault => @type.id
    add_column         :matches,         :technical,          :integer,             :default => 3
    add_column         :matches,         :physical,           :integer,             :default => 3
    change_column      :matches,         :type_id,            :integer,             :detault => 3

    # @matches = Match.find(:all, :conditions => "description is null")
    # @matches.each { |match| match.description = '.....'; match.position_id = @type.id; match.save! }
    # 
    # Match.find(:all, :conditions => "description is not null").each { |match| match.position_id = @type.id; match.save! }
        
  end

  def self.down
    remove_column         :matches,         :position_id
    remove_column         :matches,         :technical
    remove_column         :matches,         :physical
    change_column         :matches,         :type_id,            :integer
  end
end
