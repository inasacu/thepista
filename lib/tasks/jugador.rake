# to run:    sudo rake thejugador

desc "creating a wall, also archive all unactive users...for each user. call with RAILS_ENV=production or it defaults to development"
task :thejugador => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  
  

  # users = (User.find :all, :conditions => ['archive = false']).collect {|user| user unless user.email.blank? }.compact
  # users.each do |user|
  #   
  #   user.last_login_at = user.updated_at
  #   user.save!
  #   
  #   if Blog.find_by_user_id(user.id).nil?
  #     blog = Blog.new
  #     blog.user_id = user.id
  #     blog.name = '...'
  #     blog.description = '...'
  #     blog.save!
  #   end
  #   
  #   # if Entry.find_by_user_id(user.id).nil?
  #   if Entry.find(:first, :conditions => ["user_id = ?", user.id]).nil?
  #     entry = Entry.new
  #     entry.blog_id = user.blog.id
  #     entry.user_id = user.id
  #     entry.title = '...'
  #     entry.body = '...' 
  #     entry.save!
  #     puts "#{user.name} entry created..."
  #   end
  # 
  #   # if Comment.find_by_user_id(user.id).nil?
  #   if Comment.find(:first, :conditions => ["user_id = ?", user.id]).nil?
  #     comment = Comment.new
  #     comment.entry_id = user.blog.entries.first.id
  #     comment.user_id = user.id
  #     comment.body = '...' 
  #     comment.save!
  #     puts "#{user.name} comment created..."
  #   end
  #   
  # end
  
  # archive all unactive users w/n 6 months 
  # users = User.find(:all, :conditions => ["archive = false and id not in (select user_id from groups_users) " +
  #                                        "and id not in (select user_id from roles_users " +
  #                                        "where roles_users.role_id in (select id from roles where name = 'maximo'))"])
  # users.each do |user|    
  #   user.email = 'archive_user@archive.com' if user.email.nil?
  #   user.name = user.email unless user.email.nil?
  #   user.description = user.email unless user.email.nil?
  #   user.archive = true
  #   user.save!
  #   puts "#{user.name} set to archive status..."
  # end
  
end

