# to run:    rake clean_marker_name

desc "clean marker name to make smaller string"
task :clean_marker_name => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)
	
	# RolesUsers.create(:user_id => 2001, :role_id => 72608)

	the_search = "Centro Deportivo"
	the_replacement = 'C.D.'
	change_marker_name(the_search, the_replacement)

	the_search = "Centro Deportivo Municipal"
	the_replacement = 'C.D.M.'
	change_marker_name(the_search, the_replacement)

	the_search = "Ciudad Deportiva"
	the_replacement = 'C.D.'
	change_marker_name(the_search, the_replacement)

	the_search = "Complejo Deportivo"
	the_replacement = 'C.D.'
	change_marker_name(the_search, the_replacement)

	the_search = "Recinto Ferial"
	the_replacement = 'R.F.'
	change_marker_name(the_search, the_replacement)	

	the_search = "Universidad"
	the_replacement = 'Univ.'
	change_marker_name(the_search, the_replacement)

	the_search = "Colegio"
	the_replacement = 'Col.'
	change_marker_name(the_search, the_replacement)

	the_search = "Pabellon"
	the_replacement = 'Pab.'
	change_marker_name(the_search, the_replacement)

	the_search = "Centro Deportivo Municipal"
	the_replacement = 'C.D.M.'
	change_venue_name(the_search, the_replacement)
end

def change_venue_name(the_search, the_replacement)		
	@the_items = Venue.find(:all, :conditions => ["venues.name like ?", "%#{the_search}%"])
	@the_items.each do |item|
		puts item.name.gsub(the_search, the_replacement)
		item.name = item.name.gsub(the_search, the_replacement)
		item.save
	end
end

def change_marker_name(the_search, the_replacement)		
	@the_items = Marker.find(:all, :conditions => ["markers.name like ?", "%#{the_search}%"])
	@the_items.each do |item|
		puts item.name.gsub(the_search, the_replacement)
		item.name = item.name.gsub(the_search, the_replacement)
		item.save
	end
end