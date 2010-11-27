class AddRatesUser < ActiveRecord::Migration
  def self.up    
    rename_column :rates, :user_id, :rater_id
    
    add_index :rates, :rater_id
  end

  def self.down
    rename_column :rates, :rater_id, :user_id
  end
end
