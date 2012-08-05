class AddForumPracticeField < ActiveRecord::Migration
  def self.up
    
     # rake db:migrate VERSION=20090828013436
    
      add_column      :forums,    :practice_id,     :integer
      change_column   :users,     :language,        :string,    :default => 'es'
  end

  def self.down
  end
end
