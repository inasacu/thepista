# to run:    heroku run rake the_unused_schedule -a thepista

desc "remove all unused schedules and matches and update scorecards"
task :the_unused_schedule => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	the_archives = []
	counter = 0

  @schedules = Schedule.find(:all, :conditions => ["archive = false and played = false and starts_at < ?", Time.zone.now - 30.days])
  @schedules.each {|archive_file| the_archives << archive_file}

  @archive = Match.find(:all, :conditions => ["archive = false and schedule_id in (?)", @schedules])
  @archive.each {|archive_file| the_archives << archive_file}
	

  the_archives.each do |the_archive|
    puts "#{the_archive.id}  ARCHIVE #{the_archive.class.to_s} archived files removed (#{counter})"
    the_archive.archive = true
		the_archive.save
    counter += 1
  end

  the_archives = []

end

