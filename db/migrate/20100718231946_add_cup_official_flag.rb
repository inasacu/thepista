class AddCupOfficialFlag < ActiveRecord::Migration
  def self.up
    add_column    :cups,    :official,      :boolean,     :default => false
  end

  def self.down
  end
end
