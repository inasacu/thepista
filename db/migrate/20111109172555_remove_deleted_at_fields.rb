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
    add_column  :users,             :deleted_at,      :datetime
    add_column  :roles,             :deleted_at,      :datetime
    add_column  :sports,            :deleted_at,      :datetime
    add_column  :groups,            :deleted_at,      :datetime
    add_column  :markers,           :deleted_at,      :datetime
    add_column  :matches,           :deleted_at,      :datetime
    add_column  :messages,          :deleted_at,      :datetime
    add_column  :schedules,         :deleted_at,      :datetime
    add_column  :scorecards,        :deleted_at,      :datetime
    add_column  :teammates,         :deleted_at,      :datetime
    add_column  :fees,              :deleted_at,      :datetime
    add_column  :payments,          :deleted_at,      :datetime
    add_column  :invitations,       :deleted_at,      :datetime
    add_column  :standings,         :deleted_at,      :datetime
    add_column  :classifieds,       :deleted_at,      :datetime
    add_column  :cups,              :deleted_at,      :datetime
    add_column  :escuadras,         :deleted_at,      :datetime
    add_column  :challenges,        :deleted_at,      :datetime
    
    add_column  :groups_markers,    :deleted_at,      :datetime
    add_column  :groups_users,      :deleted_at,      :datetime
    add_column  :groups_roles,      :deleted_at,      :datetime
    add_column  :cups_escuadras,    :deleted_at,      :datetime
    add_column  :roles_users,       :deleted_at,      :datetime
    add_column  :challenges_users,  :deleted_at,      :datetime
  end
end
