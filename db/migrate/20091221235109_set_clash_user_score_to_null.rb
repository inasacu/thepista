class SetClashUserScoreToNull < ActiveRecord::Migration
  def self.up
    change_column     :clashes,       :user_score,      :integer,        :default => nil
  end

  def self.down
    change_column     :clashes,       :user_score,      :integer,        :default => 0
  end
end
