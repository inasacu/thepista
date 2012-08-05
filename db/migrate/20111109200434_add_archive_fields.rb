class AddArchiveFields < ActiveRecord::Migration
  def self.up

    add_column        :rates,               :archive,     :boolean,       :default => false
    add_column        :conversations,       :archive,     :boolean,       :default => false
    add_column        :challenges_users,    :archive,     :boolean,       :default => false
    add_column        :cups_escuadras,      :archive,     :boolean,       :default => false
    add_column        :games,               :archive,     :boolean,       :default => false
    add_column        :groups_markers,      :archive,     :boolean,       :default => false
    add_column        :groups_roles,        :archive,     :boolean,       :default => false
    add_column        :groups_users,        :archive,     :boolean,       :default => false
    add_column        :teammates,           :archive,     :boolean,       :default => false
  end

  def self.down
  end
end
