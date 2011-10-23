# to run:    sudo rake the_archive_marker

desc "ARCHIVE a marker"
task :the_archive_marker => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  the_marker = Marker.find(:first, :conditions => "id = 49")
  puts the_marker.name
  the_marker.archive = true
  the_marker.save
  
end


