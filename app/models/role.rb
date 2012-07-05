# TABLE "roles"
# t.string   "name"              
# t.string   "authorizable_type" 
# t.integer  "authorizable_id"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.boolean  "archive"

class Role < ActiveRecord::Base
  
	acts_as_authorization_role :join_table_name => :roles_users

  has_many    :roles_users,     :dependent => :delete_all
  has_many    :users,           :through => :roles_users
  has_many    :groups,          :through => :roles_groups 
  belongs_to  :authorizable,    :polymorphic => true
end