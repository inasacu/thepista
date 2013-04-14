# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130407162528) do

  create_table "announcements", :force => true do |t|
    t.text     "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "casts", :force => true do |t|
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "home_score"
    t.integer  "away_score"
    t.integer  "points",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",      :default => false
    t.string   "slug"
  end

  add_index "casts", ["challenge_id"], :name => "index_casts_on_challenge_id"
  add_index "casts", ["game_id"], :name => "index_casts_on_game_id"
  add_index "casts", ["slug"], :name => "index_casts_on_slug", :unique => true
  add_index "casts", ["user_id"], :name => "index_casts_on_user_id"

  create_table "challenges", :force => true do |t|
    t.string   "name"
    t.integer  "cup_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "reminder_at"
    t.float    "fee_per_game",       :default => 0.0
    t.string   "time_zone"
    t.text     "description"
    t.text     "conditions"
    t.integer  "player_limit",       :default => 99
    t.boolean  "archive",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "automatic_petition", :default => true
    t.string   "slug"
    t.integer  "service_id",         :default => 51
  end

  add_index "challenges", ["cup_id"], :name => "index_challenges_on_cup_id"
  add_index "challenges", ["slug"], :name => "index_challenges_on_slug", :unique => true

  create_table "challenges_users", :id => false, :force => true do |t|
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",      :default => false
  end

  add_index "challenges_users", ["challenge_id"], :name => "index_challenges_users_on_challenge_id"
  add_index "challenges_users", ["user_id"], :name => "index_challenges_users_on_user_id"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "state_id",   :default => 1
    t.boolean  "archive",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",    :default => false
  end

  create_table "cups", :force => true do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "deadline_at"
    t.string   "time_zone"
    t.integer  "sport_id"
    t.boolean  "group_stage",         :default => true
    t.boolean  "group_stage_single",  :default => true
    t.boolean  "second_stage_single", :default => true
    t.boolean  "final_stage_single",  :default => true
    t.integer  "group_stage_advance", :default => 16
    t.integer  "points_for_win",      :default => 3
    t.integer  "points_for_draw",     :default => 1
    t.integer  "points_for_lose",     :default => 0
    t.text     "description"
    t.text     "conditions"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "archive",             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "official",            :default => false
    t.boolean  "club",                :default => true
    t.string   "slug"
    t.integer  "venue_id",            :default => 1
  end

  add_index "cups", ["slug"], :name => "index_cups_on_slug", :unique => true
  add_index "cups", ["sport_id"], :name => "index_cups_on_sport_id"

  create_table "cups_escuadras", :id => false, :force => true do |t|
    t.integer  "cup_id"
    t.integer  "escuadra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",     :default => false
  end

  add_index "cups_escuadras", ["cup_id"], :name => "index_cups_escuadras_on_cup_id"
  add_index "cups_escuadras", ["escuadra_id"], :name => "index_cups_escuadras_on_escuadra_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text     "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  create_table "enchufados", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "language"
    t.integer  "venue_id"
    t.integer  "category_id"
    t.integer  "play_id"
    t.integer  "service_id"
    t.string   "api"
    t.string   "secret"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "escuadras", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "archive",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "slug"
    t.boolean  "official",           :default => false
  end

  add_index "escuadras", ["item_id"], :name => "index_escuadras_on_item_id"
  add_index "escuadras", ["slug"], :name => "index_escuadras_on_slug", :unique => true

  create_table "fees", :force => true do |t|
    t.string   "name",          :limit => 50
    t.text     "description"
    t.string   "payed",                       :default => "No"
    t.boolean  "archive",                     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "debit_amount",                :default => 0.0
    t.integer  "debit_id"
    t.string   "debit_type"
    t.integer  "credit_id"
    t.string   "credit_type"
    t.integer  "manager_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "type_id"
    t.boolean  "season_player",               :default => false
    t.string   "slug"
  end

  add_index "fees", ["credit_id", "credit_type"], :name => "index_fees_on_credit_id_and_credit_type"
  add_index "fees", ["debit_id", "debit_type"], :name => "index_fees_on_debit_id_and_debit_type"
  add_index "fees", ["item_id", "item_type"], :name => "index_fees_on_item_id_and_item_type"
  add_index "fees", ["manager_id"], :name => "index_fees_on_manager_id"
  add_index "fees", ["slug"], :name => "index_fees_on_slug", :unique => true
  add_index "fees", ["type_id"], :name => "index_fees_on_type_id"

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "reminder_at"
    t.datetime "deadline_at"
    t.integer  "cup_id"
    t.integer  "home_id"
    t.integer  "away_id"
    t.integer  "winner_id"
    t.integer  "next_game_id"
    t.integer  "home_ranking"
    t.string   "home_stage_name"
    t.integer  "away_ranking"
    t.string   "away_stage_name"
    t.integer  "home_score"
    t.integer  "away_score"
    t.integer  "jornada",                                  :default => 1
    t.integer  "round",                                    :default => 1
    t.boolean  "played",                                   :default => false
    t.string   "type_name",                  :limit => 40
    t.integer  "points_for_single",                        :default => 0
    t.integer  "points_for_double",                        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points_for_draw",                          :default => 0
    t.integer  "points_for_goal_difference",               :default => 0
    t.integer  "points_for_goal_total",                    :default => 0
    t.integer  "points_for_winner",                        :default => 0
    t.boolean  "archive",                                  :default => false
    t.string   "slug"
  end

  add_index "games", ["away_id"], :name => "index_games_on_away_id"
  add_index "games", ["cup_id"], :name => "index_games_on_cup_id"
  add_index "games", ["home_id"], :name => "index_games_on_home_id"
  add_index "games", ["next_game_id"], :name => "index_games_on_next_game_id"
  add_index "games", ["slug"], :name => "index_games_on_slug", :unique => true
  add_index "games", ["winner_id"], :name => "index_games_on_winner_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "second_team"
    t.datetime "gameday_at"
    t.float    "points_for_win",     :default => 1.0
    t.float    "points_for_draw",    :default => 0.0
    t.float    "points_for_lose",    :default => 0.0
    t.string   "time_zone",          :default => "UTC"
    t.integer  "sport_id"
    t.integer  "marker_id"
    t.text     "description"
    t.text     "conditions"
    t.integer  "player_limit",       :default => 150
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "archive",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "automatic_petition", :default => true
    t.integer  "installation_id"
    t.string   "slug"
    t.integer  "service_id",         :default => 51
    t.integer  "item_id"
    t.string   "item_type"
  end

  add_index "groups", ["marker_id"], :name => "index_groups_on_marker_id"
  add_index "groups", ["slug"], :name => "index_groups_on_slug", :unique => true
  add_index "groups", ["sport_id"], :name => "index_groups_on_sport_id"

  create_table "groups_markers", :force => true do |t|
    t.integer  "group_id"
    t.integer  "marker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",    :default => false
  end

  add_index "groups_markers", ["group_id"], :name => "index_groups_markers_on_group_id"
  add_index "groups_markers", ["marker_id"], :name => "index_groups_markers_on_marker_id"

  create_table "groups_roles", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",    :default => false
  end

  add_index "groups_roles", ["group_id"], :name => "index_groups_roles_on_group_id"
  add_index "groups_roles", ["role_id"], :name => "index_groups_roles_on_role_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",    :default => false
  end

  add_index "groups_users", ["group_id"], :name => "index_groups_users_on_group_id"
  add_index "groups_users", ["user_id"], :name => "index_groups_users_on_user_id"

  create_table "holidays", :force => true do |t|
    t.string   "name"
    t.integer  "venue_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "holiday_hour", :default => true
    t.boolean  "archive",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_id"
  end

  add_index "holidays", ["type_id"], :name => "index_holidays_on_type_id"
  add_index "holidays", ["venue_id"], :name => "index_holidays_on_venue_id"

  create_table "installations", :force => true do |t|
    t.string   "name"
    t.integer  "venue_id"
    t.integer  "sport_id"
    t.integer  "marker_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.float    "timeframe",          :default => 1.0
    t.float    "fee_per_pista",      :default => 0.0
    t.float    "fee_per_lighting",   :default => 0.0
    t.boolean  "public",             :default => true
    t.boolean  "lighting",           :default => true
    t.boolean  "outdoor",            :default => true
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "description"
    t.text     "conditions"
    t.boolean  "archive",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "installations", ["marker_id"], :name => "index_installations_on_marker_id"
  add_index "installations", ["slug"], :name => "index_installations_on_slug", :unique => true
  add_index "installations", ["sport_id"], :name => "index_installations_on_sport_id"
  add_index "installations", ["venue_id"], :name => "index_installations_on_venue_id"

  create_table "invitations", :force => true do |t|
    t.string   "email_addresses"
    t.text     "message"
    t.integer  "user_id"
    t.boolean  "archive",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.string   "item_type"
  end

  add_index "invitations", ["item_id", "item_type"], :name => "index_invitations_on_item_id_and_item_type"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.string   "item_type"
    t.float    "lat",                                                        :default => 0.0
    t.float    "lng",                                                        :default => 0.0
    t.string   "slug"
    t.string   "short_name"
  end

  add_index "markers", ["item_id", "item_type"], :name => "index_markers_on_item_id_and_item_type"
  add_index "markers", ["slug"], :name => "index_markers_on_slug", :unique => true

  create_table "matches", :force => true do |t|
    t.integer  "schedule_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "invite_id",                                                           :default => 0
    t.integer  "group_score"
    t.integer  "invite_score"
    t.integer  "goals_scored",                                                        :default => 0
    t.integer  "roster_position",                                                     :default => 0
    t.boolean  "played",                                                              :default => false
    t.string   "one_x_two",                :limit => 1
    t.string   "user_x_two",               :limit => 1
    t.integer  "type_id"
    t.datetime "status_at",                                                           :default => '2009-10-12 16:02:12'
    t.boolean  "archive",                                                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rating_average_technical",              :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "rating_average_physical",               :precision => 6, :scale => 2, :default => 0.0
    t.float    "initial_mean",                                                        :default => 0.0
    t.float    "initial_deviation",                                                   :default => 0.0
    t.float    "final_mean",                                                          :default => 0.0
    t.float    "final_deviation",                                                     :default => 0.0
    t.integer  "game_number",                                                         :default => 0
    t.string   "block_token"
    t.integer  "change_id"
    t.datetime "changed_at"
  end

  add_index "matches", ["group_id"], :name => "index_matches_on_group_id"
  add_index "matches", ["invite_id"], :name => "index_matches_on_invite_id"
  add_index "matches", ["schedule_id"], :name => "index_matches_on_schedule_id"
  add_index "matches", ["type_id"], :name => "index_matches_on_type_id"
  add_index "matches", ["user_id"], :name => "index_matches_on_user_id"

  create_table "messages", :force => true do |t|
    t.string   "subject",                    :limit => 150
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
    t.integer  "replies",                                   :default => 0
    t.integer  "reviews",                                   :default => 0
    t.boolean  "archive",                                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "received_messageable_id"
    t.string   "received_messageable_type"
    t.integer  "sent_messageable_id"
    t.string   "sent_messageable_type"
    t.boolean  "opened",                                    :default => false
    t.boolean  "recipient_delete",                          :default => false
    t.boolean  "sender_delete",                             :default => false
    t.string   "ancestry"
    t.boolean  "recipient_permanent_delete",                :default => false
    t.boolean  "sender_permanent_delete",                   :default => false
  end

  add_index "messages", ["ancestry"], :name => "index_messages_on_ancestry"
  add_index "messages", ["conversation_id"], :name => "index_messages_on_conversation_id"
  add_index "messages", ["item_id", "item_type"], :name => "index_messages_on_item_id_and_item_type"
  add_index "messages", ["parent_id"], :name => "index_messages_on_parent_id"
  add_index "messages", ["recipient_id"], :name => "index_messages_on_recipient_id"
  add_index "messages", ["reply_id"], :name => "index_messages_on_reply_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"
  add_index "messages", ["sent_messageable_id", "received_messageable_id"], :name => "acts_as_messageable_ids"

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
    t.string   "name",          :limit => 150
    t.float    "debit_amount",                 :default => 0.0
    t.float    "credit_amount",                :default => 0.0
    t.text     "description"
    t.boolean  "archive",                      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "debit_id"
    t.string   "debit_type"
    t.integer  "credit_id"
    t.string   "credit_type"
    t.integer  "manager_id"
    t.integer  "fee_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.string   "slug"
  end

  add_index "payments", ["credit_id", "credit_type"], :name => "index_payments_on_credit_id_and_credit_type"
  add_index "payments", ["debit_id", "debit_type"], :name => "index_payments_on_debit_id_and_debit_type"
  add_index "payments", ["fee_id"], :name => "index_payments_on_fee_id"
  add_index "payments", ["item_id", "item_type"], :name => "index_payments_on_item_id_and_item_type"
  add_index "payments", ["manager_id"], :name => "index_payments_on_manager_id"
  add_index "payments", ["slug"], :name => "index_payments_on_slug", :unique => true

  create_table "prospects", :force => true do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "email"
    t.string   "email_additional"
    t.string   "phone"
    t.string   "url"
    t.string   "url_additional"
    t.datetime "letter_first"
    t.datetime "letter_second"
    t.datetime "response_first"
    t.datetime "response_second"
    t.text     "notes"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "image"
    t.text     "installations"
    t.text     "description"
    t.text     "conditions"
    t.boolean  "archive",          :default => false
  end

  create_table "reservations", :force => true do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "reminder_at"
    t.integer  "venue_id"
    t.integer  "installation_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.float    "fee_per_pista",    :default => 0.0
    t.float    "fee_per_lighting", :default => 0.0
    t.boolean  "available",        :default => true
    t.boolean  "reminder",         :default => true
    t.boolean  "public",           :default => true
    t.text     "description"
    t.string   "block_token"
    t.boolean  "archive",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.string   "slug"
  end

  add_index "reservations", ["installation_id"], :name => "index_reservations_on_installation_id"
  add_index "reservations", ["item_id", "item_type"], :name => "index_reservations_on_item_id_and_item_type"
  add_index "reservations", ["slug"], :name => "index_reservations_on_slug", :unique => true
  add_index "reservations", ["venue_id"], :name => "index_reservations_on_venue_id"

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",                         :default => false
  end

  add_index "roles", ["archive"], :name => "index_roles_on_archive"
  add_index "roles", ["authorizable_id"], :name => "index_roles_on_authorizable_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",    :default => false
  end

  add_index "roles_users", ["archive"], :name => "index_roles_users_on_archive"
  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "schedules", :force => true do |t|
    t.string   "name"
    t.string   "season"
    t.integer  "jornada"
    t.datetime "starts_at"
    t.datetime "ends_at"
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
    t.integer  "player_limit",        :default => 0
    t.boolean  "played",              :default => false
    t.boolean  "public",              :default => true
    t.boolean  "archive",             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reminder",            :default => true
    t.datetime "reminder_at"
    t.datetime "send_reminder_at"
    t.datetime "send_result_at"
    t.datetime "send_comment_at"
    t.string   "slug"
    t.datetime "send_created_at"
  end

  add_index "schedules", ["group_id"], :name => "index_schedules_on_group_id"
  add_index "schedules", ["marker_id"], :name => "index_schedules_on_marker_id"
  add_index "schedules", ["slug"], :name => "index_schedules_on_slug", :unique => true
  add_index "schedules", ["sport_id"], :name => "index_schedules_on_sport_id"

  create_table "scorecards", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "wins",                :default => 0
    t.integer  "draws",               :default => 0
    t.integer  "losses",              :default => 0
    t.float    "points",              :default => 0.0
    t.integer  "ranking",             :default => 0
    t.integer  "played",              :default => 0
    t.integer  "assigned",            :default => 0
    t.integer  "goals_for",           :default => 0
    t.integer  "goals_against",       :default => 0
    t.integer  "goals_scored",        :default => 0
    t.integer  "previous_points",     :default => 0
    t.integer  "previous_ranking",    :default => 0
    t.integer  "previous_played",     :default => 0
    t.integer  "payed",               :default => 0
    t.boolean  "archive",             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "season_ends_at"
    t.integer  "field_goal_attempt",  :default => 0
    t.integer  "field_goal_made",     :default => 0
    t.integer  "free_throw_attempt",  :default => 0
    t.integer  "free_throw_made",     :default => 0
    t.integer  "three_point_attempt", :default => 0
    t.integer  "three_point_made",    :default => 0
    t.integer  "rebounds_defense",    :default => 0
    t.integer  "rebounds_offense",    :default => 0
    t.integer  "minutes_played",      :default => 0
    t.integer  "assists",             :default => 0
    t.integer  "steals",              :default => 0
    t.integer  "blocks",              :default => 0
    t.integer  "turnovers",           :default => 0
    t.integer  "personal_fouls",      :default => 0
    t.integer  "started",             :default => 0
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_limit",                  :default => 150
  end

  create_table "standings", :force => true do |t|
    t.integer  "cup_id"
    t.integer  "challenge_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "group_stage_name"
    t.integer  "wins",             :default => 0
    t.integer  "draws",            :default => 0
    t.integer  "losses",           :default => 0
    t.integer  "points",           :default => 0
    t.integer  "played",           :default => 0
    t.integer  "ranking",          :default => 0
    t.integer  "goals_for",        :default => 0
    t.integer  "goals_against",    :default => 0
    t.boolean  "archive",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "standings", ["challenge_id"], :name => "index_standings_on_challenge_id"
  add_index "standings", ["cup_id"], :name => "index_standings_on_cup_id"
  add_index "standings", ["item_id"], :name => "index_standings_on_item_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.boolean  "archive",    :default => false
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "sub_item_id"
    t.string   "sub_item_type"
    t.boolean  "archive",                     :default => false
  end

  add_index "teammates", ["group_id"], :name => "index_teammates_on_group_id"
  add_index "teammates", ["item_id"], :name => "index_teammates_on_item_id"
  add_index "teammates", ["manager_id"], :name => "index_teammates_on_manager_id"
  add_index "teammates", ["sub_item_id"], :name => "index_teammates_on_sub_item_id"
  add_index "teammates", ["user_id"], :name => "index_teammates_on_user_id"

  create_table "timetables", :force => true do |t|
    t.string   "day_of_week"
    t.integer  "installation_id"
    t.integer  "type_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.float    "timeframe",       :default => 1.0
    t.boolean  "archive",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timetables", ["installation_id"], :name => "index_timetables_on_installation_id"
  add_index "timetables", ["type_id"], :name => "index_timetables_on_type_id"

  create_table "types", :force => true do |t|
    t.string   "name",       :limit => 40
    t.string   "table_type", :limit => 40
    t.integer  "table_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "types", ["table_id"], :name => "index_types_on_table_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                   :default => "",    :null => false
    t.string   "identity_url"
    t.string   "language",                                :default => "es"
    t.string   "time_zone",                               :default => "UTC"
    t.string   "phone"
    t.string   "login"
    t.boolean  "teammate_notification",                   :default => true
    t.boolean  "message_notification",                    :default => true
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                                          :null => false
    t.integer  "login_count",                             :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.boolean  "private_phone",                           :default => false
    t.boolean  "private_profile",                         :default => false
    t.text     "description"
    t.string   "gender"
    t.datetime "birth_at"
    t.boolean  "archive",                                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",                        :default => "",    :null => false
    t.datetime "last_contacted_at"
    t.boolean  "active",                                  :default => true
    t.datetime "profile_at"
    t.string   "company",                  :limit => 120
    t.boolean  "last_minute_notification",                :default => true
    t.integer  "city_id",                                 :default => 1
    t.string   "email_backup"
    t.string   "sport"
    t.string   "linkedin_url"
    t.string   "linkedin_token"
    t.string   "linkedin_secret"
    t.string   "slug"
    t.boolean  "validation",                              :default => false
    t.boolean  "whatsapp",                                :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["identity_url"], :name => "index_users_on_identity_url"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "time_zone"
    t.integer  "marker_id"
    t.boolean  "enable_comments",     :default => true
    t.boolean  "public",              :default => true
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "description"
    t.boolean  "archive",             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "day_light_savings",   :default => true
    t.datetime "day_light_starts_at"
    t.datetime "day_light_ends_at"
    t.string   "slug"
    t.string   "short_name"
  end

  add_index "venues", ["marker_id"], :name => "index_venues_on_marker_id"
  add_index "venues", ["slug"], :name => "index_venues_on_slug", :unique => true

end
