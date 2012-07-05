# TABLE "conversations"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.boolean  "archive"

class Conversation < ActiveRecord::Base
  has_many :messages, :order => :created_at
end
