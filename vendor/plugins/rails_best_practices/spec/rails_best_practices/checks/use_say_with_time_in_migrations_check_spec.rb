require 'spec_helper'

describe RailsBestPractices::Checks::UseSayWithTimeInMigrationsCheck do
  before :each do
    @runner = RailsBestPractices::Core::Runner.new(RailsBestPractices::Checks::UseSayWithTimeInMigrationsCheck.new)
  end

  it "should use say with time in migrations" do
    content =<<-EOF
    def self.up
      User.find_each do |user|
        user.first_name, user.last_name = user.full_name.split(' ')
        user.save
      end
    end
    EOF
    @runner.check('db/migrate/20101010080658_update_users.rb', content)
    errors = @runner.errors
    errors.should_not be_empty
    errors.size.should == 1
    errors[0].to_s.should == "db/migrate/20101010080658_update_users.rb:2 - use say with time in migrations"
  end

  it "should not use say with time in migrations" do
    content =<<-EOF
    def self.up
      say_with_time("Initialize first_name and last_name for users") do
        User.find_each do |user|
          user.first_name, user.last_name = user.full_name.split(' ')
          user.save
          say(user.id + " was updated.")
        end
      end
    end
    EOF
    @runner.check('db/migrate/20101010080658_update_users.rb', content)
    errors = @runner.errors
    errors.should be_empty
  end

  it "should not use say with time when default migration message" do
    content =<<-EOF
    def self.up
      create_table :users do |t|
        t.string :login
        t.string :email
        t.timestamps
      end
    end
    EOF
    @runner.check('db/migrate/20101010080658_create_users.rb', content)
    errors = @runner.errors
    errors.should be_empty
  end

  it "should not raise an error" do
    content =<<-EOF
    class AddAdmin < ActiveRecord::Migration

      class Person < ActiveRecord::Base  
      end
      
      class Blog < ActiveRecord::Base
      end

      def self.up
        add_column :people, :admin, :boolean, :default => false, :null => false
        add_column :people, :deactivated, :boolean, 
                            :default => false, :null => false
        
        key = Crypto::Key.from_file("\#{RAILS_ROOT}/rsa_key.pub")
        person = Person.new(:email => "admin@example.com",
                            :name => "admin",
                            :crypted_password => key.encrypt("admin"),
                            :description => "")
        person.admin = true
        person.save!
        Blog.create(:person_id => person.id)
      end

      def self.down
        remove_column :people, :deactivated
        Person.delete(Person.find_by_name("admin"))
        remove_column :people, :admin
      end
    end
    EOF
    @runner.check('db/migrate/20101010080658_create_users.rb', content)
    errors = @runner.errors
    errors.should be_empty
  end
end
