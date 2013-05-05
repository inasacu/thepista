# to run:    heroku run rake restore_marker_name -a thepista

desc "restore marker name to make smaller string"
task :restore_marker_name => :environment do |t|

	the_replacement = "Centro Deportivo"
	the_search = 'C.D.'
	change_marker_name(the_search, the_replacement)

	the_replacement = "Centro Deportivo Municipal"
	the_search = 'C.D.M.'
	change_marker_name(the_search, the_replacement)

	the_replacement = "Ciudad Deportiva"
	the_search = 'C.D.'
	change_marker_name(the_search, the_replacement)

	the_replacement = "Complejo Deportivo"
	the_search = 'C.D.'
	change_marker_name(the_search, the_replacement)

	the_replacement = "Recinto Ferial"
	the_search = 'R.F.'
	change_marker_name(the_search, the_replacement)	

	the_replacement = "Universidad"
	the_search = 'Univ.'
	change_marker_name(the_search, the_replacement)

	the_replacement = "Colegio"
	the_search = 'Col.'
	change_marker_name(the_search, the_replacement)

	the_replacement = "Pabellon"
	the_search = 'Pab.'
	change_marker_name(the_search, the_replacement)

	the_replacement = "Centro Deportivo Municipal"
	the_search = 'C.D.M.'
	change_venue_name(the_search, the_replacement)
end

def change_venue_name(the_search, the_replacement)		
	@the_items = Venue.find(:all, :conditions => ["venues.name like ?", "%#{the_search}%"])
	@the_items.each do |item|
		puts item.name.gsub(the_search, the_replacement)
		item.short_name = item.name
		item.name = item.name.gsub(the_search, the_replacement)
		item.save
	end
end

def change_marker_name(the_search, the_replacement)		
	@the_items = Marker.find(:all, :conditions => ["markers.name like ?", "%#{the_search}%"])
	@the_items.each do |item|
		puts item.name.gsub(the_search, the_replacement)
		item.short_name = item.name
		item.name = item.name.gsub(the_search, the_replacement)
		item.save
	end
end