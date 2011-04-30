class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  
  belongs_to :commentable, :polymorphic => true
  belongs_to  :entry

  default_scope :order => 'created_at DESC'

  before_create   :format_body
  after_create :send_message_blog

  # NOTE: Comments belong to a user
  belongs_to :user


  # method section  
  def self.latest_items(items, user)
    user_id = ""
    commentable_id = ""
    commentable_type = ""
    
    find(:all, :select => "distinct comments.id, comments.user_id, comments.commentable_id, comments.commentable_type, comments.updated_at as created_at", 
         :joins => "left join groups_users on groups_users.user_id = comments.user_id left join challenges_users on challenges_users.user_id = comments.user_id",    
         :conditions => ["(groups_users.group_id in (?)  or challenges_users.challenge_id in (?)) and comments.updated_at >= ? and comments.archive = false", user.groups, user.challenges, LAST_WEEK],
         :order => "comments.user_id, comments.commentable_id, comments.commentable_type, comments.updated_at desc").each do |item| 
           
           # only add unique values
           unless (user_id == item.user_id and commentable_id == item.commentable_id and commentable_type == item.commentable_type)
             user_id = item.user_id 
             commentable_id = item.commentable_id 
             commentable_type = item.commentable_type
             items << item  
           end
    end
    return items 
  end
  
  private

  def format_body
    self.body.gsub!(/\r?\n/, "<br>") unless self.body.nil?
  end

  def send_message_blog      
    @item = ''
    
    
    
    
    case self.commentable_type
    when "Forum"
      @item = Forum.find(self.commentable_id)
      @group = @item.schedule.group

      the_label = @item.schedule.concept.to_s.strip[0..25]
      
      @group.users.each do |user|
        UserMailer.delay.deliver_message_blog(user, self.user, self, the_label) if user.forum_message?
      end      

    when "Blog"
      @item = Blog.find(self.commentable_id)

      case @item.item_type
      when "User"
        if self.commentable.user 
          the_label = self.commentable.user.name.to_s.strip[0..25]
          UserMailer.delay.deliver_message_blog(self.commentable.user, self.user, self, the_label) if self.commentable.user.blog_message?
        end
      when "Group"
        @group = Group.find(@item.item_id)

        @group.users.each do |user|
          the_label = @group.name.to_s.strip[0..25]
          UserMailer.delay.deliver_message_blog(user, self.user, self, the_label) if user.blog_message?
        end
          
      when "Challenge"
        @challenge = Challenge.find(@item.item_id)
        
        @challenge.users.each do |user|
          the_label = @challenge.name.to_s.strip[0..25]
          UserMailer.delay.deliver_message_blog(user, self.user, self, the_label) if user.blog_message?
        end
        
      else
      end
      
    else
    end
    
  end
  
  def self.exists?(commentable_id, commentable_type, user)
    if self.count(:conditions => ["commentable_id = ? and commentable_type = ? and user_id = ? and created_at >= ?", 
      commentable_id, commentable_type, user.id, LAST_24_HOURS]) > 1
      return false
    end
    return true
  end

end
