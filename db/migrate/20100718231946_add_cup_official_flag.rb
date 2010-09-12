class AddCupOfficialFlag < ActiveRecord::Migration
  def self.up
    add_column    :cups,    :official,      :boolean,     :default => false
    
    # update single cup to an official cup
    sql = %(UPDATE cups set official = true)
    ActiveRecord::Base.connection.execute(sql)    
  end

  def self.down
    remove_column     :cups,      :official
  end
end
