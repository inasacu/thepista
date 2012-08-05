class AddForumPracticeField < ActiveRecord::Migration
  def self.up
      # add_column      :forums,    :practice_id,     :integer
      change_column   :users,     :language,        :string,    :default => 'es'
  end

  def self.down
  end
end
