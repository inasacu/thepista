class AddInvitationTableAndId < ActiveRecord::Migration
  def self.up
    add_column        :invitations,     :item_id,      :integer
    add_column        :invitations,     :item_type,    :string
    
    add_index         :invitations,      [:item_id, :item_type]
  end

  def self.down
  end
end
