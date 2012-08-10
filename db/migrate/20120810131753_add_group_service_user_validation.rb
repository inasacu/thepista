class AddGroupServiceUserValidation < ActiveRecord::Migration
  def up
		add_column			:users,					:validation,			:boolean,				:default => false
		add_column			:groups,				:service_id,			:integer,				:default => 51
		add_column			:challenges,		:service_id,			:integer,				:default => 51
  end

  def down
  end
end
