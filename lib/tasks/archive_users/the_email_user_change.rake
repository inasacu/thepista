# to run:    sudo rake the_email_user_change

desc "changes a specific user email address for a new email address"
task :the_email_user_change => :environment do |t|

  User.find(:all, :conditions => " email = 'esther.freire@chep.com' ").each do |user|
    puts "#{user.name} - #{user.email}"

    unless user.email == 'babiayeah@hotmail.com'
      user.email = 'babiayeah@hotmail.com'
      user.save!
    end

		puts "#{user.name} - #{user.email}"
  end

end



