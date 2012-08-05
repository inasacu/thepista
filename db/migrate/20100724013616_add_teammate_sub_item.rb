class AddTeammateSubItem < ActiveRecord::Migration
  def self.up
    add_column        :teammates,     :sub_item_id,       :integer
    add_column        :teammates,     :sub_item_type,     :string
    add_column        :casts,         :archive,           :boolean,       :default => false
    add_column        :cups,          :club,              :boolean,       :default => true  # cups w clubs are only for groups signup instead of users
  end

  def self.down
  end
end