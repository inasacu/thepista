class ChangeInvitationMessageType < ActiveRecord::Migration
  def self.up    
    change_column   :invitations,     :message,     :text
  end

  def self.down
    change_column   :invitations,     :message,     :string
  end
end
