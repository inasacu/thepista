class RenameUserIdentifierUrl < ActiveRecord::Migration
  def up
		rename_column :users, :identity_url, :identifier
  end

  def down
  end
end
