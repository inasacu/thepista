class AddGroupItemType < ActiveRecord::Migration
  def up
  	add_column		:groups, 		:item_id,			:integer					# 1
		add_column		:groups,		:item_type,		:string						# enchufados
  end

  def down
  end
end
