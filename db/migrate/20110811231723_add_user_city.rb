class AddUserCity < ActiveRecord::Migration
  def self.up
    add_column      :users,         :city_id,    :integer, :default => 1

    User.find(:all, :conditions => "archive = false").each do |user|
      user.city_id = 1
      user.save
    end

  end

  def self.down
    remove_column     :users,         :city_id
  end
end
