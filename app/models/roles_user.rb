# TABLE "roles_users" 
# t.integer  "user_id"
# t.integer  "role_id"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.boolean  "archive"

class RolesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end
