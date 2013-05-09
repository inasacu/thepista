# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  name              :string(40)
#  authorizable_type :string(40)
#  authorizable_id   :integer
#  created_at        :datetime
#  updated_at        :datetime
#  archive           :boolean          default(FALSE)
#

class Role < ActiveRecord::Base
  
	acts_as_authorization_role :join_table_name => :roles_users

  has_many    :roles_users,     :dependent => :delete_all
  has_many    :users,           :through => :roles_users
  has_many    :groups,          :through => :roles_groups 
  belongs_to  :authorizable,    :polymorphic => true
end
