class AddArchiveFields < ActiveRecord::Migration
  def self.up

    # add_column        :rates,               :archive,     :boolean,       :default => false
    add_column        :conversations,       :archive,     :boolean,       :default => false
    add_column        :challenges_users,    :archive,     :boolean,       :default => false
    add_column        :cups_escuadras,      :archive,     :boolean,       :default => false
    add_column        :games,               :archive,     :boolean,       :default => false
    add_column        :groups_markers,      :archive,     :boolean,       :default => false
    add_column        :groups_roles,        :archive,     :boolean,       :default => false
    add_column        :groups_users,        :archive,     :boolean,       :default => false
    add_column        :teammates,           :archive,     :boolean,       :default => false

    all_archive = Rate.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end

    all_archive = Conversation.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end
    
    all_archive = Game.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end
    
    all_archive = Teammate.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end
    
    all_archive = ChallengesUsers.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end
    
    all_archive = CupsEscuadras.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end
    
    all_archive = GroupsMarkers.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end
    
    all_archive = GroupsRoles.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end
    
    all_archive = GroupsUsers.find(:all)
    all_archive.each do |the_archive|
      the_archive.archive = false
      the_archive.save
    end
    
  end

  def self.down
  end
end
