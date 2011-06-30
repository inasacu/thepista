class AddReservationCode < ActiveRecord::Migration
  def self.up
    add_column        :reservations,          :code,                      :string 
    # add_column        :reservations,          :purchase_id,               :integer
    add_column        :venues,                :day_light_savings,         :boolean,     :default => true
    add_column        :venues,                :day_light_starts_at,       :datetime
    add_column        :venues,                :day_light_ends_at,         :datetime
  end

  def self.down
    remove_column       :reservations,        :code
    # remove_column       :reservations,        :purchase_id
    remove_column       :venues,              :day_light_savings
    remove_column       :venues,              :day_light_starts_at
    remove_column       :venues,              :day_light_ends_at
  end
end