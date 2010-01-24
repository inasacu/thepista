# to run:    sudo rake thecomment

desc "replacing all user, group and tournament comments for one generic an removing the entries"
task :thecomment => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
  # get latest activity before migration
  max_activity = Activity.find(:first, :conditions => "id = (select max(id) from activities)")
  puts "max activity: (#{max_activity.id}) #{max_activity.item_type} - #{max_activity.item_id}"
    
  Comment.find(:all, :conditions => "commentable_type = 'Forum'").each do |comment|
    comment.destroy
  end
  # migrating blog comment to new comments table
  
  Comment.find(:all).each do |comment|
    puts "comment: (#{comment.id})"
    @blog = comment.entry.blog
    if @blog
      comment.commentable = @blog 
      comment.save!
      puts "comment: (#{comment.id}) #{@blog.name}"
    else
      puts "comment destroy: (#{comment.id}) "
      # comment.destroy
    end
  end

  
  # migrating forum posts to comments table
  Post.find(:all).each do |post|
    @topic = post.topic
    if @topic
      @forum = post.topic.forum
      puts @forum.name
      @forum.comments.create(:body => post.body, :user => post.user) 
      puts "post: (#{post.id})"
    else
      puts "post destroy: (#{post.id}) "
      # post.destroy
    end
  end
  
  # remove all generated activities
  Activity.find(:all, :conditions => ["id > ?", max_activity.id]).each do |activity|
    puts "removed activity: (#{activity.id}) #{activity.item_type} - #{activity.item_id}"
    activity.destroy
  end
end