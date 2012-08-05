class RemoveDeletedAtFields < ActiveRecord::Migration
  def self.up
    remove_column   :users,             :deleted_at
    remove_column   :roles,             :deleted_at
    remove_column   :sports,            :deleted_at
    remove_column   :groups,            :deleted_at
    remove_column   :markers,           :deleted_at
    remove_column   :matches,           :deleted_at
    remove_column   :messages,          :deleted_at
    remove_column   :schedules,         :deleted_at
    remove_column   :scorecards,        :deleted_at
    remove_column   :teammates,         :deleted_at
    remove_column   :fees,              :deleted_at
    remove_column   :payments,          :deleted_at
    remove_column   :invitations,       :deleted_at
    remove_column   :standings,         :deleted_at
    remove_column   :classifieds,       :deleted_at
    remove_column   :cups,              :deleted_at
    remove_column   :escuadras,         :deleted_at
    remove_column   :challenges,        :deleted_at
    
    remove_column   :groups_markers,    :deleted_at
    remove_column   :groups_users,      :deleted_at
    remove_column   :groups_roles,      :deleted_at
    remove_column   :cups_escuadras,    :deleted_at
    remove_column   :roles_users,       :deleted_at
    remove_column   :challenges_users,  :deleted_at
  end

  def self.down
  end
end
