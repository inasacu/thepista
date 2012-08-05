class CreateTeammates < ActiveRecord::Migration
  def self.up
    create_table :teammates do |t|
      t.integer       :user_id
      t.integer       :group_id
      t.integer       :manager_id
      
      t.string        :status,            :limit => 50
      t.datetime      :accepted_at
      t.string        :teammate_code,     :limit => 40
      
      t.datetime      :deleted_at
      t.timestamps
    end
      add_index     :teammates,   :user_id
      add_index     :teammates,   :group_id
      add_index     :teammates,   :manager_id
  end

  def self.down
  end
end
