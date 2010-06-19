class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  include ActivityLogger

  belongs_to :commentable, :polymorphic => true
  belongs_to  :entry

  default_scope :order => 'created_at DESC'

  before_create   :format_body
  after_create    :log_activity, :send_message_blog

  # NOTE: Comments belong to a user
  belongs_to :user


  private

  def format_body
    self.body.gsub!(/\r?\n/, "<br>") unless self.body.nil?
  end

  def log_activity
    unless (self.user.nil?) 
      if Comment.exists?(self.commentable_id, self.commentable_type, self.user)
        activity = Activity.create!(:item => self, :user => self.user)
      end
    end
  end

  def send_message_blog      
    @item = ''
    case self.commentable_type
    when "Forum"
      @item = Forum.find(self.commentable_id)
      @group = @item.schedule.group

      @group.users.each do |user|
        @send_mail ||= user.forum_comment_notification?
        UserMailer.send_later(:deliver_message_blog, user, self.user, self) if @send_mail 
      end      

    when "Blog"
      @item = Blog.find(self.commentable_id)

      case @item.item_type
      when "User"
        if self.commentable.user 
          @send_mail ||= self.commentable.user.blog_comment_notification?
          UserMailer.send_later(:deliver_message_blog, self.commentable.user, self.user, self) if @send_mail
        end
      when "Group"
        @group = Group.find(@item.item_id)

        @group.users.each do |user|
          @send_mail ||= user.blog_comment_notification?
          UserMailer.send_later(:deliver_message_blog, user, self.user, self) if @send_mail 
        end
          
      when "Challenge"
        @challenge = Challenge.find(@item.item_id)
        
        @challenge.users.each do |user|
          @send_mail ||= user.blog_comment_notification?
          UserMailer.send_later(:deliver_message_blog, user, self.user, self) if @send_mail 
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
