# to run:    heroku run rake the_escuadra_official -a thepista

desc "set currenct escuadras to official"
task :the_escuadra_official => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	# escuadras
	@escuadras = Escuadra.find(:all, :conditions => "official = false and item_type = 'Escuadra'")
	@escuadras.each do |escuadra|
		escuadra.official = true
		escuadra.save
	end
	
	
	@the_group_markers = GroupsMarkers.find(:all, :conditions => "group_id not in (select id from groups )")
	@the_group_markers.each do |the_group_marker|
		the_group_marker.archive = true
		the_group_marker.save
	end
	
	@the_markers = Marker.find(:all, :conditions => "id in (select marker_id from groups_markers where archive = true )")
	@the_markers.each do |the_marker|
		the_marker.archive = true
		the_marker.save
	end
end