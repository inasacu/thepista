# to run:    sudo rake thejornada

desc "generate a forum, topic and post for already created schedules. call with RAILS_ENV=production or it defaults to development"
task :thejornada => :environment do |t|

  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  schedules = (Schedule.find :all).collect {|s| s }.compact  
  schedules.each do |schedule|

    @description = "...."
    @description = schedule.description unless schedule.description.blank?
    
    manager = schedule.group.the_managers.first.user_id
    
    if Forum.find_by_schedule_id(schedule.id).nil?
      forum = Forum.new
      forum.schedule_id = schedule.id
      forum.name = schedule.concept
      forum.description = @description
      forum.save!
    end
    
    if Topic.find_by_forum_id(schedule.forum.id).nil?
      topic = Topic.new
      topic.forum_id = schedule.forum.id
      topic.user_id = manager
      topic.name = schedule.concept
      topic.save!
    end   
    
    if Post.find_by_topic_id(schedule.forum.topics.first.id).nil?
      post = Post.new
      post.topic_id = schedule.forum.topics.first.id
      post.user_id = manager
      post.body = @description
      post.save!
    end
    
    forum = Forum.find_by_schedule_id(schedule.id)
    forum.name = schedule.concept
    forum.save!
    
    topic = Topic.find_by_forum_id(schedule.forum.id)
    topic.name = schedule.concept
    topic.save!
      

    # @forum = Forum.find_by_schedule_id(schedule.id)
    # if @forum.nil?
    #   Forum.create(:schedule_id => schedule.id, :name => schedule.concept, :description => schedule.description) 
    #     puts "#{schedule.concept } forum created..."
    # 
    #     @forum = Forum.find_by_schedule_id(schedule.id)  
    #     puts "#{@forum.name } forum found..."  
    # end 
    
    # @topic = Topic.find_by_forum_id(@forum.id) unless @forum.nil?
    # if @topic.nil?
    #   topic.create(:forum_id => @forum.id, :user_id => manager_id, :name => schedule.concept)
    #     puts "#{schedule.concept } topic created..."
    #     
    #     @topic = topic.find_by_forum_id(@forum.id)  
    #     puts "#{@forum.name } forum found..."  
    # end
    
    # @post = Post.find_by_topic_id(@topic.id)
    # if @post.nil?
    #   Post.create(:topic_id => @topic.id, :user_id => manager_id, :body => schedule.description)
    #     puts "#{schedule.concept } post created..."
    # end
    
  end
  
end
