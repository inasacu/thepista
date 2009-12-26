class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  include ActivityLogger

  belongs_to :commentable, :polymorphic => true
  belongs_to  :entry
  
  default_scope :order => 'created_at DESC'

  before_create   :format_body
  after_create    :log_activity, :send_message_blog
  
  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
  

  private
  
  def format_body
    self.body.gsub!(/\r?\n/, "<br>") unless self.body.nil?
  end
  
  def log_activity
    add_activities(:item => self, :user => self.user) unless (self.user.nil?) 
  end
  
  def send_message_blog   
    unless self.commentable_type == 'Forum'
      if self.commentable.user 
        @send_mail ||= self.commentable.user.blog_comment_notification?
        UserMailer.send_later(:deliver_message_blog, self.commentable.user, self.user, self) if @send_mail
      end
    end
  end
  
end
