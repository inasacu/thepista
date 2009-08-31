# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091231190225) do

  create_table "blogs", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "entries_count", :default => 0, :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogs", ["group_id"], :name => "index_blogs_on_group_id"
  add_index "blogs", ["user_id"], :name => "index_blogs_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["entry_id"], :name => "index_comments_on_entry_id"

  create_table "conversations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.integer  "blog_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "title"
    t.text     "body"
    t.integer  "comments_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["blog_id"], :name => "index_entries_on_blog_id"

  create_table "fees", :force => true do |t|
    t.string   "concept",      :limit => 50
    t.text     "description"
    t.string   "payed",                      :default => "No"
    t.integer  "schedule_id"
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "archive",                    :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "debit_amount",               :default => 0.0
    t.integer  "debit_id"
    t.string   "debit_type"
    t.integer  "credit_id"
    t.string   "credit_type"
    t.integer  "manager_id"
    t.boolean  "season_payed",               :default => false
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.integer  "schedule_id"
    t.integer  "topics_count", :default => 0, :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "practice_id"
  end

  add_index "forums", ["schedule_id"], :name => "index_forums_on_schedule_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "second_team"
    t.datetime "gameday_at"
    t.integer  "technical"
    t.integer  "physical"
    t.boolean  "private_profile",    :default => false
    t.float    "points_for_win",     :default => 1.0
    t.float    "points_for_draw",    :default => 0.0
    t.float    "points_for_lose",    :default => 0.0
    t.string   "time_zone",          :default => "UTC"
    t.integer  "sport_id"
    t.integer  "marker_id"
    t.text     "description"
    t.text     "conditions"
    t.integer  "player_limit",       :default => 99
    t.string   "blog_title"
    t.integer  "entries_count",      :default => 0,     :null => false
    t.integer  "comments_count",     :default => 0,     :null => false
    t.boolean  "enable_comments",    :default => true
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "archive",            :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "available",          :default => true,  :null => false
  end

  create_table "groups_markers", :force => true do |t|
    t.integer  "group_id"
    t.integer  "marker_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markers", :force => true do |t|
    t.string   "name",        :limit => 150,                                 :default => ""
    t.decimal  "latitude",                   :precision => 15, :scale => 10
    t.decimal  "longitude",                  :precision => 15, :scale => 10
    t.string   "direction"
    t.string   "image_url"
    t.string   "url"
    t.string   "contact",     :limit => 150
    t.string   "email"
    t.string   "phone",       :limit => 40
    t.string   "address",                                                    :default => ""
    t.string   "city",                                                       :default => ""
    t.string   "region",      :limit => 40,                                  :default => ""
    t.string   "zip",         :limit => 40,                                  :default => ""
    t.string   "surface"
    t.string   "facility"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "time_zone",                                                  :default => "UTC"
    t.boolean  "public",                                                     :default => true
    t.boolean  "activation",                                                 :default => false
    t.text     "description"
    t.string   "icon",        :limit => 100,                                 :default => ""
    t.string   "shadow",      :limit => 100,                                 :default => ""
    t.boolean  "archive",                                                    :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.string   "name",                         :default => "Match Day"
    t.integer  "schedule_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "invite_id",                    :default => 0
    t.integer  "group_score"
    t.integer  "invite_score"
    t.integer  "goals_scored",                 :default => 0
    t.integer  "roster_position",              :default => 0
    t.boolean  "played",                       :default => false
    t.boolean  "available",                    :default => true
    t.string   "one_x_two",       :limit => 1
    t.string   "user_x_two",      :limit => 1
    t.integer  "type_id"
    t.datetime "status_at",                    :default => '2009-08-08 22:26:16'
    t.text     "description"
    t.boolean  "archive",                      :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["group_id"], :name => "index_matches_on_group_id"
  add_index "matches", ["invite_id"], :name => "index_matches_on_invite_id"
  add_index "matches", ["schedule_id"], :name => "index_matches_on_schedule_id"
  add_index "matches", ["user_id"], :name => "index_matches_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "subject",              :limit => 150
    t.text     "body"
    t.integer  "parent_id"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "conversation_id"
    t.integer  "reply_id"
    t.datetime "replied_at"
    t.datetime "sender_deleted_at"
    t.datetime "sender_read_at"
    t.datetime "recipient_deleted_at"
    t.datetime "recipient_read_at"
    t.integer  "replies",                             :default => 0
    t.integer  "reviews",                             :default => 0
    t.boolean  "archive",                             :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["conversation_id"], :name => "index_messages_on_conversation_id"
  add_index "messages", ["recipient_id"], :name => "index_messages_on_recipient_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "payments", :force => true do |t|
    t.string   "concept",       :limit => 150
    t.float    "debit_amount",                 :default => 0.0
    t.float    "credit_amount",                :default => 0.0
    t.text     "description"
    t.string   "table_type",    :limit => 40
    t.integer  "table_id"
    t.integer  "type_id"
    t.boolean  "archive",                      :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "debit_id"
    t.string   "debit_type"
    t.integer  "credit_id"
    t.string   "credit_type"
    t.integer  "manager_id"
    t.integer  "fee_id"
    t.integer  "parent_id"
  end

  create_table "posts", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"

  create_table "practice_attendees", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "practice_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "practices", :force => true do |t|
    t.string   "concept"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "reminder"
    t.integer  "practice_attendees_count", :default => 0
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "sport_id"
    t.integer  "marker_id"
    t.string   "time_zone",                :default => "UTC"
    t.text     "description"
    t.integer  "player_limit"
    t.boolean  "played",                   :default => false
    t.boolean  "privacy",                  :default => true
    t.boolean  "archive",                  :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.string   "concept"
    t.string   "season"
    t.integer  "jornada"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "reminder_at"
    t.datetime "subscription_at"
    t.datetime "non_subscription_at"
    t.float    "fee_per_game",        :default => 0.0
    t.float    "fee_per_pista",       :default => 0.0
    t.integer  "remind_before",       :default => 2
    t.integer  "repeat_every",        :default => 7
    t.string   "time_zone",           :default => "UTC"
    t.integer  "group_id"
    t.integer  "sport_id"
    t.integer  "marker_id"
    t.integer  "player_limit",        :default => 99
    t.boolean  "played",              :default => false
    t.boolean  "public",              :default => true
    t.text     "description"
    t.boolean  "archive",             :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["group_id"], :name => "index_schedules_on_group_id"

  create_table "scorecards", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "wins",             :default => 0
    t.integer  "draws",            :default => 0
    t.integer  "losses",           :default => 0
    t.float    "points",           :default => 0.0
    t.integer  "ranking",          :default => 0
    t.integer  "played",           :default => 0
    t.integer  "assigned",         :default => 0
    t.integer  "goals_for",        :default => 0
    t.integer  "goals_against",    :default => 0
    t.integer  "goals_scored",     :default => 0
    t.integer  "previous_points",  :default => 0
    t.integer  "previous_ranking", :default => 0
    t.integer  "previous_played",  :default => 0
    t.integer  "payed",            :default => 0
    t.boolean  "archive",          :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scorecards", ["group_id"], :name => "index_scorecards_on_group_id"
  add_index "scorecards", ["user_id"], :name => "index_scorecards_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sports", :force => true do |t|
    t.string   "name",            :limit => 50
    t.text     "description"
    t.string   "icon",            :limit => 40
    t.float    "points_for_win",                :default => 3.0
    t.float    "points_for_lose",               :default => 0.0
    t.float    "points_for_draw",               :default => 1.0
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teammates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "manager_id"
    t.string   "status",        :limit => 50
    t.datetime "accepted_at"
    t.string   "teammate_code", :limit => 40
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teammates", ["group_id"], :name => "index_teammates_on_group_id"
  add_index "teammates", ["manager_id"], :name => "index_teammates_on_manager_id"
  add_index "teammates", ["user_id"], :name => "index_teammates_on_user_id"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "posts_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "types", :force => true do |t|
    t.string   "name",       :limit => 40
    t.string   "table_type", :limit => 40
    t.integer  "table_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                      :default => "",    :null => false
    t.string   "openid_identifier"
    t.string   "identity_url"
    t.string   "language",                   :default => "es"
    t.string   "time_zone",                  :default => "UTC"
    t.string   "phone"
    t.string   "position"
    t.string   "dorsal"
    t.integer  "technical"
    t.integer  "physical"
    t.string   "login"
    t.integer  "rpxnow_id"
    t.integer  "posts_count",                :default => 0,     :null => false
    t.integer  "entries_count",              :default => 0,     :null => false
    t.integer  "comments_count",             :default => 0,     :null => false
    t.string   "blog_title"
    t.boolean  "enable_comments",            :default => true
    t.boolean  "teammate_notification",      :default => true
    t.boolean  "message_notification",       :default => true
    t.boolean  "blog_comment_notification",  :default => true
    t.boolean  "forum_comment_notification", :default => true
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                             :null => false
    t.integer  "login_count",                :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.boolean  "private_phone",              :default => false
    t.boolean  "private_profile",            :default => false
    t.text     "description"
    t.string   "gender"
    t.datetime "birth_at"
    t.boolean  "archive",                    :default => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",           :default => "",    :null => false
    t.boolean  "available",                  :default => true,  :null => false
    t.datetime "last_contacted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["openid_identifier"], :name => "index_users_on_openid_identifier"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
