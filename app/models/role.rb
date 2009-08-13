class Role < ActiveRecord::Base
  acts_as_authorization_role

  has_many :roles_users, :dependent => :delete_all
  has_many :users, :through => :roles_users
  belongs_to :authorizable, :polymorphic => true
end
