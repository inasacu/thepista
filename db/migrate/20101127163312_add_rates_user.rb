class AddRatesUser < ActiveRecord::Migration
  def self.up    
    rename_column :rates, :user_id, :rater_id
    
    add_index :rates, :rater_id
  end

  def self.down
  end
end
