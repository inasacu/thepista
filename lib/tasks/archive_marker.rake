# to run:    sudo rake the_archive_marker

desc "ARCHIVE a marker"
task :the_archive_marker => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  the_marker = Marker.find(:first, :conditions => "name = 'Centro Deportivo La Masó'")
  puts the_marker.name
  the_marker.archive = false
  the_marker.save
  
end


