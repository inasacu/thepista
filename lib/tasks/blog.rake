# to run:    sudo rake theblog

desc "replace '...' in blog name and description for real name and description ie:  user, group, tournament"
task :theblog => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  puts "users"
  Blog.find(:all, :conditions => ["user_id is not null and item_id is null"], :order => "id").each do |blog|
    puts blog.id
    blog.item = blog.user
    blog.save!
  end
  puts "groups"
  Blog.find(:all, :conditions => ["group_id is not null and item_id is null"], :order => "id").each do |blog|
    puts blog.id
    blog.item = blog.group
    blog.save!
  end
end