class FieldChangesFeePaymentStanding < ActiveRecord::Migration
  def up
		add_column				:standings,			:user_id,				:integer
  end

  def down
		remove_column				:standings,			:user_id,				:integer
  end
end
