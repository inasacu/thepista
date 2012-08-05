class AddUsersPasswordResetFields < ActiveRecord::Migration
  def self.up
    add_column 		:users, 	:perishable_token, 		:string, 	:default => "", 		:null => false  
		change_column :users, 	:email, 				:string, 	:default => "", 		:null => false  
		 
		# other fields to add or remove
		add_column		:users,		:available,				:boolean,	:default => true,		:null => false
		add_column		:groups,	:available,				:boolean,	:default => true,		:null => false
		
		remove_column	:users, 	:default_email
		remove_column	:users,		:default_available
		remove_column	:groups,	:default_available
	
		add_index :users, :perishable_token  
		add_index :users, :email
  end

  def self.down
  end
end
