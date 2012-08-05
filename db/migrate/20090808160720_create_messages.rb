class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string      :subject,                     :limit => 150
      t.text        :body
      
      t.integer     :parent_id
      t.integer     :sender_id
      t.integer     :recipient_id
      t.integer     :conversation_id
      t.integer     :reply_id
      
      t.datetime    :replied_at
      
      t.datetime    :sender_deleted_at
      t.datetime    :sender_read_at
      
      t.datetime    :recipient_deleted_at
      t.datetime    :recipient_read_at
      
      t.integer     :replies,                     :default => 0
      t.integer     :reviews,                     :default => 0
            
      t.boolean     :archive,             :default => false
      t.datetime    :deleted_at
      t.timestamps
    end    
    add_index       :messages,       :conversation_id
    add_index       :messages,       :sender_id
    add_index       :messages,       :recipient_id
  end

  def self.down
  end
end
