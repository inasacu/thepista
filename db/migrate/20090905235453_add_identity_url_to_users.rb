class AddIdentityUrlToUsers < ActiveRecord::Migration
  def self.up
    # add_column :users, :identity_url, :string
    add_index :users, :identity_url
    
    # change_column :users, :login, :string, :default => nil, :null => true
    # change_column :users, :crypted_password, :string, :default => nil, :null => true
    # change_column :users, :password_salt, :string, :default => nil, :null => true
  end
 
  def self.down
    # remove_column :users, :identity_url
    
    # [:login, :crypted_password, :password_salt].each do |field|
    #   User.all(:conditions => "#{field} is NULL").each { |user| user.update_attribute(field, "") if user.send(field).nil? }
    #   change_column :users, field, :string, :default => "", :null => false
    # end
  end
end

