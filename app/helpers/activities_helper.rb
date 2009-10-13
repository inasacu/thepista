module ActivitiesHelper

  # Given an activity, return a message for the feed for the activity's class.
  def feed_message(activity, recent = false)
    user = activity.user
    case activity_type(activity)

    when "Message"
        %(#{I18n.t(:sent_a_message) }.)

    when "Schedule"
      schedule = activity.item
      
      if schedule.played?
        %(#{I18n.t(:has_updated_scorecard) } #{schedule_link schedule}.)
      else        
        %(#{I18n.t(:created_a_schedule) } #{schedule_link schedule}.)
      end

    when "User"
        %(#{I18n.t(:changed_description) })
      
    when "Post"
        post = activity.item
          %(#{I18n.t(:left_post_on_forum) } #{topic_link(post.topic)})
          
    when "Comment"
        comment = activity.item
          %(#{I18n.t(:left_comment_on_wall) } #{user_link(comment.entry.user)})

    when "Match"	
          match = activity.item
      %(#{I18n.t(:changes_in_roster_status) } #{I18n.t(:in) } #{schedule_link match.schedule}.)

    when "Result"
      %(Resultados ya se han actualizado...)
      
	  when "Scorecard"
          scorecard = activity.item
      %(changed results for #{group_link scorecard.group}.)
            
      
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
              
            # when "Connection"
            #   if activity.item.contact.admin?
            #     "vcard.png"
            #   else
            #     "connect.png"
            #   end
              
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
              
            # when "Event"
            #   # TODO: replace with a png icon
            #   "time.gif"
              
            # when "EventAttendee"
            #   # TODO: replace with a png icon
            #   "check.gif"
              
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
  
  def blog_link(text, blog)
    link_to(text, blog_path(blog))
  end
  
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

  
  def entry_link(text, entry = nil)
    if entry.nil?
      entry = text
      text = entry.title
    end
    link_to(text, blog_path(entry.blog))
  end
 
  def gallery_link(text, gallery = nil)
    if gallery.nil?
      gallery = text
      text = gallery.title
    end
    link_to(h(text), gallery_path(gallery))
  end
  
  def to_gallery_link(text = nil, gallery = nil)
    if text.nil?
      ''
    else
      'to the ' + gallery_link(text, gallery) + ' gallery'
    end
  end
  
  def photo_link(text, photo= nil)
    if photo.nil?
      photo = text
      text = "photo"
    end
    link_to(h(text), photo_path(photo))
  end

  def event_link(text, event)
    link_to(text, event_path(event))
  end


  # Return a link to the wall.
  def wall(activity)
    commenter = activity.user
    user = activity.item.commentable
    link_to("#{someones(user, commenter, false)} wall",
            user_path(user, :anchor => "tWall"))
  end
  
  # Only show member photo for certain types of activity
  def posterPhoto(activity)
    shouldShow = case activity_type(activity)
    when "Photo"
      true
    when "Connection"
      true
    else
      false
    end
    if shouldShow
      # image_link(activity.user, :image => :thumbnail)
      image_link activity.user
    end
  end
  
  private
  
    # Return the type of activity.
    # We switch on the class.to_s because the class itself is quite long
    # (due to ActiveRecord).
    def activity_type(activity)
      activity.item.class.to_s      
    end
end
