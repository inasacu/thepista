class RemoveFeePaymentFields < ActiveRecord::Migration
  def self.up
    remove_column   :fees,    :schedule_id
    remove_column   :fees,    :group_id
    remove_column   :fees,    :user_id
  end

  def self.down
    add_column      :fees,      :schedule_id,     :integer
    add_column      :fees,      :group_id,     :integer
    add_column      :fees,      :user_id,     :integer
  end
end
