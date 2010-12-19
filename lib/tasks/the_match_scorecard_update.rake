# to run:    sudo rake the_match_scorecard_update

desc "create games based on cup teams and groups..."
task :the_match_scorecard_update => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  @the_match = Match.find(:first, :conditions =>"schedule_id = (select id from schedules where group_id = 9 limit 1)")
  the_user = User.find(2001)
  Match.update_match_details(@the_match, the_user)



  sql = "delete from delayed_jobs where handler like '%deliver_message_blog%'"
  ActiveRecord::Base.connection.execute(sql)

  namespace :db do

    desc "delete all delayed jobs that are delivering message blogs"
    task :cleanup => :environment do
      sql = <<-SQL
      -- do some cleanup code
        SQL
        # used to connect active record to the database
        ActiveRecord::Base.establish_connection
        ActiveRecord::Base.connection.execute(sql)
      end

    end



  end

