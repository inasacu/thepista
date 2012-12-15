class AddCupVenue < ActiveRecord::Migration
  def up
		add_column		:cups,			:venue_id,			:integer,			:default => 1
  end

  def down
  end
end
