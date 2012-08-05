class AddUserCompanyProfileDate < ActiveRecord::Migration
  def self.up
    add_column      :users,   :profile_at,            :datetime
    add_column      :users,   :company,               :string,         :limit => 120
    change_column   :users,   :technical,             :integer,        :default => 1
    change_column   :users,   :physical,              :integer,        :default => 1
  end

  def self.down
  end
end
