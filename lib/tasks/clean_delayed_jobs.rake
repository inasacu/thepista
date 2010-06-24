# to run:    sudo rake clean_delayed_jobs

desc "delete all delayed jobs that have failed..."
task :clean_delayed_jobs => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  sql = "delete from delayed_jobs where last_error is not null"
  ActiveRecord::Base.connection.execute(sql)
  # This is really nice way to execute queries within rake tasks. In the following example I show how you would establish a database connection as well:

  namespace :db do

    desc "delete all delayed jobs that have failed..."
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