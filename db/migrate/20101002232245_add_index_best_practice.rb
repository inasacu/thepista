class AddIndexBestPractice < ActiveRecord::Migration
  def self.up
    add_index :activities, :user_id
    add_index :blogs, :item_id
    add_index :casts, :challenge_id
    add_index :casts, :user_id
    add_index :casts, :game_id
    add_index :challenges, :cup_id
    add_index :challenges_users, :challenge_id
    add_index :challenges_users, :user_id
    add_index :classifieds, :table_id
    add_index :classifieds, :item_id
    add_index :comments, :group_id
    add_index :cups, :sport_id
    add_index :cups_escuadras, :cup_id
    add_index :cups_escuadras, :escuadra_id
    add_index :escuadras, :item_id
    add_index :fees, :schedule_id
    add_index :fees, :group_id
    add_index :fees, :user_id
    add_index :fees, :manager_id
    add_index :fees, :type_id
    add_index :games, :cup_id
    add_index :games, :home_id
    add_index :games, :away_id
    add_index :games, :winner_id
    add_index :games, :next_game_id
    add_index :groups, :sport_id
    add_index :groups, :marker_id
    add_index :groups_markers, :group_id
    add_index :groups_markers, :marker_id
    add_index :groups_roles, :group_id
    add_index :groups_roles, :role_id
    add_index :groups_users, :group_id
    add_index :groups_users, :user_id
    add_index :invitations, :user_id
    add_index :matches, :type_id
    add_index :matches, :position_id
    add_index :messages, :parent_id
    add_index :messages, :reply_id
    add_index :payments, :manager_id
    add_index :payments, :fee_id
    add_index :roles, :authorizable_id
    add_index :roles_users, :user_id
    add_index :roles_users, :role_id
    add_index :schedules, :sport_id
    add_index :schedules, :marker_id
    add_index :standings, :cup_id
    add_index :standings, :challenge_id
    add_index :standings, :item_id
    add_index :taggings, :tagger_id
    add_index :teammates, :item_id
    add_index :teammates, :sub_item_id
    add_index :types, :table_id
    add_index :users, :rpxnow_id
    add_index :taggings,    :taggable_id
  end

  def self.down
  end
end
