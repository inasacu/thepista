class AddAutomaticPetition < ActiveRecord::Migration
  def self.up
      add_column      :groups,        :automatic_petition,      :boolean,         :default => true
      add_column      :challenges,    :automatic_petition,      :boolean,         :default => true
  end

  def self.down
  end
end
