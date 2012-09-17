class AddUserWhatsappOption < ActiveRecord::Migration
  def up
		add_column			:users,				:whatsapp,				:boolean,					:default => false
  end

  def down
	remove_column			:users,				:whatsapp
  end
end
