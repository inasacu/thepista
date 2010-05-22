module ActivitiesHelper

  # Given an activity, return a message for the feed for the activity's class.
  def feed_message(activity, current_user, recent = false)
    user = activity.user
    is_member = false
      
      
    case activity_type(activity)
    when "Message"
        %(#{I18n.t(:sent_a_message) }.)

    when "Schedule"
      schedule = activity.item
      is_member = current_user.is_member_of?(schedule.group)
      the_label = schedule.played? ? I18n.t(:has_updated_scorecard) : I18n.t(:created_a_schedule)
       %(#{the_label} #{is_member ? team_roster_link(schedule) : sanitize(schedule.concept)}.<br/>)

    when "User"
        %(#{I18n.t(:changed_description) })
      
    when "Post"
        post = activity.item
        is_member = false
        
        if post.topic.forum.schedule        
          is_member = current_user.is_member_of?(post.topic.forum.schedule.group)        
            %(#{I18n.t(:left_post_on_forum) } #{is_member ? topic_link(post.topic): sanitize(post.topic.forum.schedule.concept)}<br/>)
        elsif post.topic.forum.meet        
          is_member = current_user.is_tour_member_of?(post.topic.forum.meet.tournament)        
            %(#{I18n.t(:left_post_on_forum) } #{is_member ? topic_link(post.topic): sanitize(post.topic.forum.meet.concept)}<br/>)
        end
        
    when "Comment"
      comment = activity.item
      
      case comment_type(comment)
      when "Blog"
        blog = comment.commentable
        case blog.item_type
        when "User"
            %(#{I18n.t(:left_comment_on_wall) } #{blog_link_item(blog)}<br/>)
        when "Group", "Challenge"
             is_member = current_user.is_member_of?(blog.item)
             %(#{I18n.t(:left_post_on_forum)} #{is_member ? blog_link_item(blog) : sanitize(blog.item.name)}<br/>)
        end
      
      when "Forum"
        forum = comment.commentable
        is_member = false
        
        if forum.schedule        
          is_member = current_user.is_member_of?(forum.schedule.group)        
            %(#{I18n.t(:left_post_on_forum) } #{is_member ? forum_link(forum): sanitize(forum.schedule.concept)}<br/>)
        elsif forum.meet        
          is_member = current_user.is_tour_member_of?(forum.meet.tournament)        
            %(#{I18n.t(:left_post_on_forum) } #{is_member ? forum_link(forum): sanitize(forum.meet.concept)}<br/>)
        end
      else
        ""
      end      
        

    when "Match"	
          match = activity.item
          is_member = false
          
          match = activity.item
          is_member = current_user.is_member_of?(match.schedule.group)
          %(#{I18n.t(:changes_in_roster_status) } #{I18n.t(:in) } #{is_member ? team_roster_link(match.schedule) : sanitize(match.schedule.concept)}.<br/>)
    
    when "Clash"  
          clash = activity.item
          is_member = false
    
          clash = activity.item
          is_member = current_user.is_tour_member_of?(clash.meet.tournament)
          %(#{I18n.t(:changes_in_roster_status) } #{I18n.t(:in) } #{is_member ? meet_link(clash.meet) : sanitize(clash.meet.concept)}.<br/>)

    when "Result"
      %(Resultados ya se han actualizado...)
      
	  when "Scorecard"
          scorecard = activity.item
          is_member = current_user.is_member_of?(scorecard.group)
      %(changed results for #{is_member ? group_link(scorecard.group) : scorecard.group.name}.<br/>)
            
    else
      raise "Invalid activity type #{activity_type(activity).inspect}"
    end
  end
  
  # Given an activity, return the right icon.
  def feed_icon(activity)
    img = case activity_type(activity)
            when "Comment"
              "page_white.png"
              
            when "Comment"
              parent_type = activity.item.commentable.class.to_s
              case parent_type
              when "Comment"
                "comment.png"
              when "Event"
                "comment.png"
              when "User"
                "sound.png"
              end

              
            when "Post"
              "asterisk_yellow.png"
              
            when "Topic"
              "note.png"
              
            when "User"
                "user_edit.png"
                
            when "Gallery"
              "photos.png"
              
            when "Photo"
              "photo.png"

              
            when "Message"
              "message.gif"
            
            when "Schedule"
                "schedule.gif"
            else
              raise "Invalid activity type #{activity_type(activity).inspect}"
            end
    image_tag("icons/#{img}", :class => "icon")
  end
  
  def someones(user, commenter, link = true)
    link ? "#{user_link_with_image(user)}'s" : "#{h user.name}'s"
  end
  
  # def blog_link(text, blog)
  #   link_to(text, blog_path(blog))
  # end
  
  def post_link(text, blog, post = nil)
    if post.nil?
      post = blog
      blog = text
      text = post.title
    end
    link_to(text, blog_post_path(blog, post))
  end
  
  def topic_link(text, topic = nil)
    if topic.nil?
      topic = text
      text = topic.name
    end
    # link_to(text, forum_topic_path(topic.forum, topic))
    link_to(text, forum_path(topic.forum))
  end

  
  # def entry_link(text, entry = nil)
  #   if entry.nil?
  #     entry = text
  #     text = entry.title
  #   end
  #   link_to(text, blog_path(entry.blog))
  # end
 
  # def gallery_link(text, gallery = nil)
  #   if gallery.nil?
  #     gallery = text
  #     text = gallery.title
  #   end
  #   link_to(h(text), gallery_path(gallery))
  # end
  
  # def to_gallery_link(text = nil, gallery = nil)
  #   if text.nil?
  #     ''
  #   else
  #     'to the ' + gallery_link(text, gallery) + ' gallery'
  #   end
  # end
  
  # def photo_link(text, photo= nil)
  #   if photo.nil?
  #     photo = text
  #     text = "photo"
  #   end
  #   link_to(h(text), photo_path(photo))
  # end

  # def event_link(text, event)
  #   link_to(text, event_path(event))
  # end


  # Return a link to the wall.
  # def wall(activity)
  #   commenter = activity.user
  #   user = activity.item.commentable
  #   link_to("#{someones(user, commenter, false)} wall",
  #           user_path(user, :anchor => "tWall"))
  # end
  
  # Only show member photo for certain types of activity
  # def posterPhoto(activity)
  #   shouldShow = case activity_type(activity)
  #   when "Photo"
  #     true
  #   when "Connection"
  #     true
  #   else
  #     false
  #   end
  #   if shouldShow
  #     # image_link(activity.user, :image => :thumbnail)
  #     image_link activity.user
  #   end
  # end
  
  private
  
    # Return the type of activity.
    # We switch on the class.to_s because the class itself is quite long
    # (due to ActiveRecord).
    def activity_type(activity)
      activity.item.class.to_s      
    end
    
    def comment_type(comment)
      comment.commentable.class.to_s      
    end
end
