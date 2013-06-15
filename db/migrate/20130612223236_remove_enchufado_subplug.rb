class RemoveEnchufadoSubplug < ActiveRecord::Migration
  def up
		drop_table		:enchufados
		drop_table		:subplugs
  end

  def down
  end
end
