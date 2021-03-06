# to run:    heroku run rake final_temporada_grupos --app zurb

desc "ARCHIVE all records related to group then reset group archive to false"
task :final_temporada_grupos => :environment do |t|


	# archive group 
	the_archives = []

	# GROUPS
	the_group_archive_query = 'archive = false and id != 14'
	
	archive = Group.where(the_group_archive_query)
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)


	# CUPS
	the_archive_false = Cup.find(:all, :conditions => "archive = false")
	the_archive_true = Cup.find(:all, :conditions => "archive = true")

	# CHALLENGES
	archive = Challenge.find(:all, :conditions => ["archive = false and cup_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Challenge.find(:all, :conditions => ["archive = false and cup_id not in (?)", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}

	# GAMES
	archive = Game.find(:all, :conditions => ["archive = false and cup_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Game.find(:all, :conditions => ["archive = false and cup_id not in (?)", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}

	# STANDINGS
	archive = Standing.find(:all, :conditions => ["archive = false and cup_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Standing.find(:all, :conditions => ["archive = false and cup_id not in (?)", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# CHALLENGES 
	the_archive_false = Challenge.find(:all, :conditions => "archive = false")
	the_archive_true = Challenge.find(:all, :conditions => "archive = true")

	# FEES
	archive = Fee.find(:all, :conditions => ["archive = false and item_id in (?) and item_type = 'Challenge'", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Fee.find(:all, :conditions => ["archive = false and item_id not in (?) and item_type = 'Challenge'", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}

	if (Challenge.find(:all).count < 1)
		archive = Fee.find(:all, :conditions => ["item_type = 'Challenge'", the_archive_false])
		archive.each {|archive_file| the_archives << archive_file}
	end

	# PAYMENTS
	archive = Payment.find(:all, :conditions => ["archive = false and item_id in (?) and item_type = 'Challenge'", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Payment.find(:all, :conditions => ["archive = false and item_id not in (?) and item_type = 'Challenge'", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}


	# STANDINGS
	archive = Standing.find(:all, :conditions => ["archive = false and challenge_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Standing.find(:all, :conditions => ["archive = false and challenge_id not in (?)", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# CASTS
	the_archive_false = Challenge.find(:all, :conditions => "archive = false")
	the_archive_true = Challenge.find(:all, :conditions => "archive = true")

	archive = Cast.find(:all, :conditions => ["archive = false and challenge_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Cast.find(:all, :conditions => ["archive = false and challenge_id not in (?)", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Standing.find(:all, :conditions => "item_id is null and item_type is null")
	archive.each {|archive_file| the_archives << archive_file}

	# GROUPS
	the_archive_false = Group.find(:all, :conditions => "archive = false")
	the_archive_true = Group.find(:all, :conditions => "archive = true")

	# FEES
	archive = Fee.find(:all, :conditions => ["archive = false and item_id in (?) and item_type = 'Group'", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Fee.find(:all, :conditions => ["archive = false and item_id not in (?) and item_type = 'Group'", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# PAYMENT
	archive = Payment.find(:all, :conditions => ["archive = false and item_id in (?) and item_type = 'Group'", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Payment.find(:all, :conditions => ["archive = false and item_id not in (?) and item_type = 'Group'", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# SCHEDULES
	archive = Schedule.find(:all, :conditions => ["archive = false and group_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Schedule.find(:all, :conditions => ["archive = false and group_id not in (?)", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)


	the_archive_false = Schedule.find(:all, :conditions => "archive = false")
	the_archive_true = Schedule.find(:all, :conditions => "archive = true")

	# MATCHES
	archive = Match.find(:all, :conditions => ["archive = false and schedule_id in (?)", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Match.find(:all, :conditions => ["archive = false and schedule_id not in (?)", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# FEES
	archive = Fee.find(:all, :conditions => ["archive = false and item_id in (?) and item_type = 'Schedule'", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Fee.find(:all, :conditions => ["archive = false and item_id not in (?) and item_type = 'Schedule'", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# PAYMENT
	archive = Payment.find(:all, :conditions => ["archive = false and item_id in (?) and item_type = 'Schedule'", the_archive_true])
	archive.each {|archive_file| the_archives << archive_file}

	archive = Payment.find(:all, :conditions => ["archive = false and item_id not in (?) and item_type = 'Schedule'", the_archive_false])
	archive.each {|archive_file| the_archives << archive_file}
	the_archives = set_all_to_archive(the_archives)

	# MESSAGES
	Message.archive_messages

	# reset all archived groups to unarchive
  # unarchives = Group.where('archive = true and item_type is null')
  # unarchives.each do |unarchive|
  #   unarchive.archive = false
  #   unarchive.save!
  # end 
	
end


def set_all_to_archive(the_archives)

	counter = 1
	the_archives.each do |the_archive|
		puts "#{the_archive.id} ARCHIVE #{the_archive.class.to_s} files (#{counter})"
		the_archive.archive = true
		the_archive.save
		counter += 1
	end

	the_archives = []
	return the_archives 

end