# to run:    sudo rake the_pista_trueskill
#  heroku rake the_pista_trueskill --app thepista

require 'rubygems'
require 'saulabs/trueskill'

include Saulabs::TrueSkill

desc "  # use the trueskill ranking system for players"
task :the_pista_trueskill => :environment do |t|

  ActiveRecord::Base.establish_connection(Rails.env.to_sym)

  groups = Group.find(:all)
  groups.each do |group| 
    puts "Analizing #{group.name} = #{group.id}"
    # if (group.id != 1)
    if group.id == 9
      Match.set_default_skill(group)
      Match.set_true_skill(group)
      puts "completed #{group.name} = #{group.id}"
    end
  end
  # end

end