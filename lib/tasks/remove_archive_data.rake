# to run:    heroku run rake the_remove_archive_data -a thepista

desc "remove all archived files not needed"
task :the_remove_archive_data => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

	
	schedule_id = 227	
	group_id = 14
	
	if Rails.env.development?
		@the_item = Schedule.find(schedule_id)
		@the_item.archive = false;
		@the_item.save

		@the_items = Match.find(:all, :conditions => ["schedule_id = ?", schedule_id])
		@the_items.each do |item|
			item.archive = false
			item.save
		end		
	end

  the_archives = []
  counter = 1

  @archive = Cast.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Challenge.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = ChallengesUsers.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Game.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Standing.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Cup.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Match.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Fee.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Payment.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Schedule.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = Role.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

  @archive = RolesUsers.find(:all, :conditions => ["archive = true"])
  @archive.each {|archive_file| the_archives << archive_file}

	
	@the_item = Group.find(group_id)
	@the_item.archive = false
	@the_item.save
	
	the_match = Match.find(:first, :conditions => ["schedule_id = ?", schedule_id], :order =>"matches.id")
	the_user = @the_item.all_the_managers.first
	Match.update_match_details(the_match, the_user)
	

  the_archives.each do |the_archive|
    puts "#{the_archive.id}  REMOVE #{the_archive.class.to_s} archived files removed (#{counter})"
    the_archive.destroy
    counter += 1
  end

  the_archives = []

end

