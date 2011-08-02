class AddAutomaticPetition < ActiveRecord::Migration
  def self.up
      add_column      :groups,        :automatic_petition,      :boolean,         :default => true
      add_column      :challenges,    :automatic_petition,      :boolean,         :default => true
  end

  def self.down
      remove_column      :groups,        :automatic_petition
      remove_column      :challenges,    :automatic_petition
  end
end
