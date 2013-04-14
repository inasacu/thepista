class CreateEnchufados < ActiveRecord::Migration
  def change
    create_table :enchufados do |t|
			t.string		:name
			t.string		:url
			t.string		:language
			t.integer		:venue_id
			t.integer		:category_id 													# sport_center, company, university, school, hospital
			t.integer		:play_id				,:default => 1   			# anyone, registered, verified  => type[61, 62, 63]
			t.integer		:service_id			,:default => 1				# core, fremium, professional, haypista => type[51, 52, 53, 54]
			t.string		:api
			t.string		:secret			
      t.timestamps
    end
  end
end
