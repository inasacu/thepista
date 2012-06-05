# to run:    rake the_archive_dependent

desc "ARCHIVE dependent records to already archived"
task :the_archive_dependent => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)
	counter = 0

	# archive group 
	has_to_archive = true
	group_id = [13, 19]  

	the_archive = Group.find(:all, :conditions => ["id in (?) and archive = false", group_id])
	the_archive.each do |group|    
		puts "archive group => #{group.name}"
		group.archive = true
		group.save if has_to_archive
	end

	# ARCHIVE flag
	has_to_archive = true  

	# ARCHIVE all CHALLENGES for CUPS archived 
	the_archive = Challenge.find(:all, :conditions => "archive = false and cup_id in (select distinct cups.id from cups where cups.archive = true)")

	the_archive.each do |challenge|
		puts "ARCHIVE challenge => #{challenge.id}, cup => #{challenge.cup.name}"
		challenge.archive = true
		challenge.save if has_to_archive
	end

	# ARCHIVE all CASTS for CHALLENGES archived 
	the_archive = Cast.find(:all, :select => "distinct *", 
	:conditions => "archive = false and challenge_id in (select distinct challenges.id from challenges where challenges.archive = true)")

	the_archive.each do |cast|
		puts "ARCHIVE cast => #{cast.id}"
		cast.archive = true
		cast.save if has_to_archive
	end 

	# ARCHIVE all SCHEDULES for GROUPS archived 
	the_schedule = Schedule.find(:all, :select => "distinct *", 
	:conditions => "archive = false and group_id in (select distinct groups.id from groups where groups.archive = true)") 

	the_schedule.each do |schedule|
		puts "ARCHIVE schedule => #{schedule.concept}"
		schedule.archive = true
		schedule.save if has_to_archive
	end

	# ARCHIVE all MATCHES for SCHEDULES archived 
	the_match = Match.find(:all, :select => "distinct *", 
	:conditions => "archive = false and schedule_id in (select distinct schedules.id from schedules where schedules.archive = true)") 

	the_match.each do |match|
		puts "ARCHIVE match => #{match.id}, schedule => #{match.schedule.concept}"
		match.archive = true
		match.save! if has_to_archive
	end


	# ARCHIVE all MATCHES where schedule_id not in all schedules not archived
	the_match = Match.find(:all, :select => "distinct *",
	:conditions => "matches.archive = false and matches.schedule_id not in (select id from schedules where  archive = false)")

	the_match.each do |match|
		puts "ARCHIVE match => #{match.id}"
		match.archive = true
		match.save! if has_to_archive
	end


	# ARCHIVE all SCORECARDS for GROUPS archived 
	the_scorecard = Scorecard.find(:all, :select => "distinct *", 
	:conditions => "archive = false and group_id in (select distinct groups.id from groups where groups.archive = true)")

	the_scorecard.each do |scorecard|
		puts "ARCHIVE scorecard => #{scorecard.id}, group => #{scorecard.group.name}"
		scorecard.archive = true
		scorecard.save if has_to_archive
	end


	# ARCHIVE all FEES for all ITEM_TYPE archived 
	the_item_types = Fee.find(:all, :select => "distinct item_type", :conditions => "archive = false")
	the_item_types.each do |fee|

		the_archive = []    
		case fee.item_type
		when "Schedule"
			the_archive = Fee.find(:all, :select => "distinct *", 
			:conditions => "archive = false and item_type = 'Schedule' and item_id in (select distinct schedules.id from schedules where schedules.archive = true)")
		when "Group"
			the_archive = Fee.find(:all, :select => "distinct *", 
			:conditions => "archive = false and item_type = 'Group' and item_id in (select distinct groups.id from groups where groups.archive = true)")
		when "Challenge"
			the_archive = Fee.find(:all, :select => "distinct *", 
			:conditions => "archive = false and item_type = 'Challenge' and item_id in (select distinct challenges.id from challenges where challenges.archive = true)")
		end  
		the_archive.each do |fee|
			puts "ARCHIVE fee => #{fee.id},  #{fee.item_id} #{fee.item_type}"
			fee.archive = true
			fee.save if has_to_archive
		end
	end
	the_archive = Fee.find(:all, :conditions => "item_type = 'Schedule' and item_id not in (select id from schedules where archive = false)")
	the_archive.each do |fee|
		puts "ARCHIVE fee => #{fee.id},  #{fee.item_id} #{fee.item_type}"
		fee.archive = true
		fee.save if has_to_archive
	end


	# ARCHIVE all PAYMENTS for all ITEM_TYPE archived 
	the_item_types = Payment.find(:all, :select => "distinct item_type", :conditions => "archive = false")
	the_item_types.each do |payment|

		the_archive = []    
		case payment.item_type
		when "Schedule"
			the_archive = Payment.find(:all, :select => "distinct *", 
			:conditions => "archive = false and item_type = 'Schedule' and item_id in (select distinct schedules.id from schedules where schedules.archive = true)")
		when "Group"
			the_archive = Payment.find(:all, :select => "distinct *", 
			:conditions => "archive = false and item_type = 'Group' and item_id in (select distinct groups.id from groups where groups.archive = true)")
		when "Challenge"
			the_archive = Payment.find(:all, :select => "distinct *", 
			:conditions => "archive = false and item_type = 'Challenge' and item_id in (select distinct challenges.id from challenges where challenges.archive = true)")
		end  
		the_archive.each do |payment|
			puts "ARCHIVE fee => #{payment.id},  #{payment.item_id} #{payment.item_type}"
			payment.archive = true
			payment.save if has_to_archive
		end
	end  



end
