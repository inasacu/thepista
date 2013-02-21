class AddMatchesChangedAt < ActiveRecord::Migration
  def up
		add_column	:matches,			:changed_at,		:datetime
  end

  def down
  end
end
