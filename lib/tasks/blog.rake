# to run:    sudo rake theblog

desc "replace '...' in blog name and description for real name and description ie:  user, group, tournament"
task :theblog => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # User.find(:all, :conditions => "archive = false").each do |user|   
  #   blog = Blog.find_by_user_id(user.id)
  #   puts user.name
  #   blog.name = user.name
  #   blog.description = user.name
  #   blog.save!
  # end
  # 
  # Group.find(:all).each do |group|
  #   blog = Blog.find_by_group_id(group.id)
  #   puts group.name
  #   blog.name = group.name
  #   blog.description = group.description
  #   blog.save!
  # end 
  # 
  # Tournament.find(:all).each do |tournament|    
  #   blog = Blog.find_by_tournament_id(tournament.id)
  #   puts tournament.name
  #   blog.name = tournament.name
  #   blog.description = tournament.description
  #   blog.save!
  # end
end

