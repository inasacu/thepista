# to run:    rake the_archive_marker  heroku rake the_archive_marker --app  haypista

desc "ARCHIVE a marker"
task :the_archive_marker => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  the_markers = Marker.find(:all, :conditions => "id in (17,79,44,15,52,76,45)")
  the_markers.each do |marker|
    puts marker.name    
    marker.destroy
  end

end


