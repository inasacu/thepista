class RemoveDefaultUserScore < ActiveRecord::Migration
  def self.up
    change_column     :clashes,       :user_score,      :integer 
  end

  def self.down
  end
end
