class AddUserEmailBackup < ActiveRecord::Migration
  def self.up
    add_column    :users,     :email_backup,      :string
    add_column    :users,     :sport,             :string
    
    User.find(:all, :conditions => "archive = false").each do |user|
      user.email_backup = user.email
      user.save
    end
    
  end

  def self.down
    remove_column   :users,     :email_backup
    remove_column   :users,     :sport
  end
end
