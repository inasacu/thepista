class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string      :email_addresses
      t.string      :message
      t.integer     :user_id
      t.boolean     :archive,           :default => false
      t.datetime    :deleted_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
