class AddIdentityUrlToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :identity_url
  end
 
  def self.down
  end
end

