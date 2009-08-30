class AddForumPracticeField < ActiveRecord::Migration
  def self.up
      add_column      :forums,    :practice_id,     :integer
  end

  def self.down
      remove_column   :forums,    :practice_id
  end
end
