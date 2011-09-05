# to run:    sudo rake the_archive_group

desc "archive specified groups"
task :the_archive_group => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # archive group 
  has_to_archive = true
  group_id = [5, 6, 8, 9, 10, 11]  

  # archive groups listed above
  the_archive = Group.find(:all, :conditions => ["id in (?) and archive = false", group_id])
  the_archive.each do |group|    
    puts "archive group => #{group.name}"
    group.archive = true
    group.save if has_to_archive
  end

end
