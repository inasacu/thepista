# to run:    sudo rake elpago

desc "fixing issues w/ fees and payment data"
task :elpago => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  @groups = Group.find(:all, :conditions => "id != 1 and archive = false")

  @groups.each do |group|
    
    puts "group:  #{group.name}"

    group.schedules.each do |schedule|

      puts "group:  #{schedule.concept}"

      group.users.each do |user|

        @fee = Fee.find(:all, 
        :conditions => ["debit_id = ? and debit_type = 'User' and 
                         credit_id = ? and credit_type = 'Group' and 
                         item_id = ? and item_type = 'Schedule'", user, group, schedule ])

          if @fee.nil? or @fee.blank? or @fee.empty?
            Fee.create_debit_credit_item_fee(user, group, schedule, user.is_subscriber_of?(group))
            puts "#{group.name} - #{user.name} #{user.id} -    #{schedule.concept} -"  
          end
          
        end
      end

    end

  end





