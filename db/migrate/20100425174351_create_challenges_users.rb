class CreateChallengesUsers < ActiveRecord::Migration
  def self.up
    create_table :challenges_users, :id => false, :force => true  do |t|
      t.integer     :challenge_id
      t.integer     :user_id      
      t.datetime    :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :challenges_users
  end
end

