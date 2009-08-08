# to run:    sudo rake theequipo

desc "add blog, entry and comments records to group"
task :theequipo => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  groups = Group.find(:all)
  groups.each do |group|
    
    if Blog.find_by_group_id(group.id).nil?
      blog = Blog.new
      blog.group_id = group.id
      blog.name = '...'
      blog.description = '...'
      blog.save!
    end
    
    if Entry.find_by_group_id(group.id).nil?
      entry = Entry.new
      entry.blog_id = group.blog.id
      entry.group_id = group.id
      entry.title = '...'
      entry.body = '...' 
      entry.save!
    end
  
    if Comment.find_by_group_id(group.id).nil?
      comment = Comment.new
      comment.entry_id = group.blog.entries.first.id
      comment.group_id = group.id
      comment.body = '...' 
      comment.save!
    end
    
  end

end

