class AddReservationsSlug < ActiveRecord::Migration
  def up
		
		add_column			:reservations,							:slug,			:string
		add_index 			:reservations, 							:slug, 			unique: true
  end

  def down
  end
end
