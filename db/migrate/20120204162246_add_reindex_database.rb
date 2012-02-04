class AddReindexDatabase < ActiveRecord::Migration
  def self.up

    remove_index "casts", ["challenge_id"]# , :name => "index_casts_on_challenge_id"
    remove_index "casts", ["game_id"]# , :name => "index_casts_on_game_id"
    remove_index "casts", ["user_id"]# , :name => "index_casts_on_user_id"

    remove_index "challenges", ["cup_id"]# , :name => "index_challenges_on_cup_id"

    remove_index "challenges_users", ["challenge_id"]# , :name => "index_challenges_users_on_challenge_id"
    remove_index "challenges_users", ["user_id"]# , :name => "index_challenges_users_on_user_id"

    remove_index "classifieds", ["item_id"]# , :name => "index_classifieds_on_item_id"
    remove_index "classifieds", ["table_id"]# , :name => "index_classifieds_on_table_id"

    remove_index "comments", ["archive"]# , :name => "index_comments_on_archive"
    remove_index "comments", ["commentable_id"]# , :name => "index_comments_on_commentable_id"
    remove_index "comments", ["commentable_type"]# , :name => "index_comments_on_commentable_type"
    remove_index "comments", ["entry_id"]# , :name => "index_comments_on_entry_id"
    remove_index "comments", ["group_id"]# , :name => "index_comments_on_group_id"
    remove_index "comments", ["user_id"]# , :name => "index_comments_on_user_id"

    remove_index "cups", ["sport_id"]# , :name => "index_cups_on_sport_id"

    remove_index "cups_escuadras", ["cup_id"]# , :name => "index_cups_escuadras_on_cup_id"
    remove_index "cups_escuadras", ["escuadra_id"]# , :name => "index_cups_escuadras_on_escuadra_id"

    remove_index "escuadras", ["item_id"]# , :name => "index_escuadras_on_item_id"

    remove_index "fees", ["credit_id", "credit_type"]# , :name => "index_fees_on_credit_id_and_credit_type"
    remove_index "fees", ["debit_id", "debit_type"]# , :name => "index_fees_on_debit_id_and_debit_type"
    remove_index "fees", ["item_id", "item_type"]# , :name => "index_fees_on_item_id_and_item_type"
    remove_index "fees", ["manager_id"]# , :name => "index_fees_on_manager_id"
    remove_index "fees", ["type_id"]# , :name => "index_fees_on_type_id"    


    remove_index "forums", ["archive"]# , :name => "index_forums_on_archive"
    remove_index "forums", ["item_id", "item_type"]# , :name => "index_forums_on_item_id_and_item_type"
    remove_index "forums", ["schedule_id"]# , :name => "index_forums_on_schedule_id"

    remove_index "games", ["away_id"]# , :name => "index_games_on_away_id"
    remove_index "games", ["cup_id"]# , :name => "index_games_on_cup_id"
    remove_index "games", ["home_id"]# , :name => "index_games_on_home_id"
    remove_index "games", ["next_game_id"]# , :name => "index_games_on_next_game_id"
    remove_index "games", ["winner_id"]# , :name => "index_games_on_winner_id"

    remove_index "groups", ["marker_id"]# , :name => "index_groups_on_marker_id"
    remove_index "groups", ["sport_id"]# , :name => "index_groups_on_sport_id"


    remove_index "groups_markers", ["group_id"]# , :name => "index_groups_markers_on_group_id"
    remove_index "groups_markers", ["marker_id"]# , :name => "index_groups_markers_on_marker_id"


    remove_index "groups_roles", ["group_id"]# , :name => "index_groups_roles_on_group_id"
    remove_index "groups_roles", ["role_id"]# , :name => "index_groups_roles_on_role_id"

    remove_index "groups_users", ["group_id"]# , :name => "index_groups_users_on_group_id"
    remove_index "groups_users", ["user_id"]# , :name => "index_groups_users_on_user_id"


    remove_index "holidays", ["type_id"]# , :name => "index_holidays_on_type_id"
    remove_index "holidays", ["venue_id"]# , :name => "index_holidays_on_venue_id"


    remove_index "installations", ["marker_id"]# , :name => "index_installations_on_marker_id"
    remove_index "installations", ["sport_id"]# , :name => "index_installations_on_sport_id"
    remove_index "installations", ["venue_id"]# , :name => "index_installations_on_venue_id"

    remove_index "invitations", ["item_id", "item_type"]# , :name => "index_invitations_on_item_id_and_item_type"
    remove_index "invitations", ["user_id"]# , :name => "index_invitations_on_user_id"


    remove_index "markers", ["item_id", "item_type"]# , :name => "index_markers_on_item_id_and_item_type"

    remove_index "matches", ["group_id"]# , :name => "index_matches_on_group_id"
    remove_index "matches", ["invite_id"]# , :name => "index_matches_on_invite_id"
    remove_index "matches", ["position_id"]# , :name => "index_matches_on_position_id"
    remove_index "matches", ["schedule_id"]# , :name => "index_matches_on_schedule_id"
    remove_index "matches", ["type_id"]# , :name => "index_matches_on_type_id"
    remove_index "matches", ["user_id"]# , :name => "index_matches_on_user_id"

    remove_index "messages", ["conversation_id"]# , :name => "index_messages_on_conversation_id"
    remove_index "messages", ["item_id", "item_type"]# , :name => "index_messages_on_item_id_and_item_type"
    remove_index "messages", ["parent_id"]# , :name => "index_messages_on_parent_id"
    remove_index "messages", ["recipient_id"]# , :name => "index_messages_on_recipient_id"
    remove_index "messages", ["reply_id"]# , :name => "index_messages_on_reply_id"
    remove_index "messages", ["sender_id"]# , :name => "index_messages_on_sender_id"

    remove_index "payments", ["credit_id", "credit_type"]# , :name => "index_payments_on_credit_id_and_credit_type"
    remove_index "payments", ["debit_id", "debit_type"]# , :name => "index_payments_on_debit_id_and_debit_type"
    remove_index "payments", ["fee_id"]# , :name => "index_payments_on_fee_id"
    remove_index "payments", ["item_id", "item_type"]# , :name => "index_payments_on_item_id_and_item_type"
    remove_index "payments", ["manager_id"]# , :name => "index_payments_on_manager_id"

    remove_index "pre_purchases", ["installation_id", "block_token"]# , :name => "index_pre_purchases_on_installation_id_and_block_token"
    remove_index "pre_purchases", ["item_id", "item_type"]# , :name => "index_pre_purchases_on_item_id_and_item_type"

    remove_index "purchases", ["item_id", "item_type"]# , :name => "index_purchases_on_item_id_and_item_type"

    remove_index "rates", ["rateable_id"]# , :name => "index_rates_on_rateable_id"
    remove_index "rates", ["rater_id"]# , :name => "index_rates_on_rater_id"
    remove_index "rates", ["rater_id"]# , :name => "index_rates_on_user_id"

    remove_index "reservations", ["installation_id"]# , :name => "index_reservations_on_installation_id"
    remove_index "reservations", ["item_id", "item_type"]# , :name => "index_reservations_on_item_id_and_item_type"
    remove_index "reservations", ["venue_id"]# , :name => "index_reservations_on_venue_id"

    remove_index "roles", ["archive"]# , :name => "index_roles_on_archive"
    remove_index "roles", ["authorizable_id"]# , :name => "index_roles_on_authorizable_id"

    remove_index "roles_users", ["archive"]# , :name => "index_roles_users_on_archive"
    remove_index "roles_users", ["role_id"]# , :name => "index_roles_users_on_role_id"
    remove_index "roles_users", ["user_id"]# , :name => "index_roles_users_on_user_id"

    remove_index "schedules", ["group_id"]# , :name => "index_schedules_on_group_id"
    remove_index "schedules", ["marker_id"]# , :name => "index_schedules_on_marker_id"
    remove_index "schedules", ["sport_id"]# , :name => "index_schedules_on_sport_id"

    remove_index "scorecards", ["group_id"]# , :name => "index_scorecards_on_group_id"
    remove_index "scorecards", ["user_id"]# , :name => "index_scorecards_on_user_id"

    remove_index "sessions", ["session_id"]# , :name => "index_sessions_on_session_id"
    remove_index "sessions", ["updated_at"]# , :name => "index_sessions_on_updated_at"

    remove_index "slugs", ["archive"]# , :name => "index_slugs_on_archive"
    remove_index "slugs", ["name", "sluggable_type", "scope", "sequence"]# , :name => "index_slugs_on_n_s_s_and_s", :unique => true
    remove_index "slugs", ["sluggable_id"]# , :name => "index_slugs_on_sluggable_id"

    remove_index "standings", ["challenge_id"]# , :name => "index_standings_on_challenge_id"
    remove_index "standings", ["cup_id"]# , :name => "index_standings_on_cup_id"
    remove_index "standings", ["item_id"]# , :name => "index_standings_on_item_id"

    remove_index "teammates", ["group_id"]# , :name => "index_teammates_on_group_id"
    remove_index "teammates", ["item_id"]# , :name => "index_teammates_on_item_id"
    remove_index "teammates", ["manager_id"]# , :name => "index_teammates_on_manager_id"
    remove_index "teammates", ["sub_item_id"]# , :name => "index_teammates_on_sub_item_id"
    remove_index "teammates", ["user_id"]# , :name => "index_teammates_on_user_id"

    remove_index "timetables", ["installation_id"]# , :name => "index_timetables_on_installation_id"
    remove_index "timetables", ["type_id"]# , :name => "index_timetables_on_type_id"
    remove_index "types", ["table_id"]# , :name => "index_types_on_table_id"

    remove_index "users", ["email"]# , :name => "index_users_on_email"
    remove_index "users", ["identity_url"]# , :name => "index_users_on_identity_url"
    remove_index "users", ["last_request_at"]# , :name => "index_users_on_last_request_at"
    remove_index "users", ["login"]# , :name => "index_users_on_login"
    remove_index "users", ["openid_identifier"]# , :name => "index_users_on_openid_identifier"
    remove_index "users", ["perishable_token"]# , :name => "index_users_on_perishable_token"
    remove_index "users", ["persistence_token"]# , :name => "index_users_on_persistence_token"
    remove_index "users", ["rpxnow_id"]# , :name => "index_users_on_rpxnow_id"

    remove_index "venues", ["marker_id"]# , :name => "index_venues_on_marker_id"
    
  end

  def self.down
  end
end