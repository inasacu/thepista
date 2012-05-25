# to run:    rake the_euro2012_point_system

desc "set default for the euro2012 cup point system"
task :the_euro2012_point_system => :environment do |t|

	ActiveRecord::Base.establish_connection(Rails.env.to_sym)
	counter = 0

	# get current cup
	@cups = Cup.find(:all, :conditions => "archive = false")

	@cups.each do |cup|
		
		puts "#{cup.name}"
		points_for_single = 0
		points_for_double = 15
		points_for_winner = 5
		points_for_draw = 3
		points_for_goal_difference = 2
		points_for_goal_total = 1
		
		puts "S:#{points_for_single}, RESULT: #{points_for_double}, W: #{points_for_winner}, D: #{points_for_draw}, GD: #{points_for_goal_difference}, G: #{points_for_goal_total}"
		
		cup.games.each do |game|

			# default point values
			game.points_for_single = points_for_single
			game.points_for_double = points_for_double
			game.points_for_winner = points_for_winner
			game.points_for_draw = points_for_draw
			game.points_for_goal_difference = points_for_goal_difference
			game.points_for_goal_total = points_for_goal_total
			
			puts "#{counter +=1}"
			game.save!

		end
	end

end
