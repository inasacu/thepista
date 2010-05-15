class AddCupConditions < ActiveRecord::Migration
  def self.up
    add_column    :cups,      :conditions,    :text
  end

  def self.down
    remove_column     :cups,    :conditions
  end
end
