# to run:    sudo rake delete_group_blog_comment

desc "delete_group_blog_comment"
task :delete_group_blog_comment => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  # delete_group_blog_comment 
  

  # archive groups listed above
  the_delete = Comment.find(:all, :conditions => ["user_id is null and group_id is not null"], :order => "id")
  the_delete.each do |comment|    
    puts "delete comment => #{comment.id}"
    comment.destroy
  end

end
