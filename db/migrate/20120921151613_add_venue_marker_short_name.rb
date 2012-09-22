class AddVenueMarkerShortName < ActiveRecord::Migration
  def up
		add_column		:markers,					:short_name,				:string
		add_column		:venues,					:short_name,				:string
  end

  def down
  end
end
