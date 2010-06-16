# to run:    sudo rake clean_delayed_jobs

desc "replacing all user, group and tournament comments for one generic an removing the entries"
task :clean_delayed_jobs => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  sql = "delete from delayed_jobs where last_error = -1"
  ActiveRecord::Base.connection.execute(sql)
  # This is really nice way to execute queries within rake tasks. In the following example I show how you would establish a database connection as well:

  namespace :db do

    desc "Cleanup the database by setting rows to deleted when older than xxx. Defaults to development database.  Set RAILS_ENV=[production, test, etc.] to override."
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