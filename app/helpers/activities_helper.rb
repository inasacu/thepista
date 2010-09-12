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
       %(#{the_label} #{is_member ? team_roster_link(schedule) : sanitize(schedule.concept)}.&nbsp;&nbsp;&nbsp;&nbsp;)

    when "User"
        %(#{I18n.t(:changed_description) })
        
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
             %(#{I18n.t(:left_post_on_forum)} #{is_member ? blog_link_item(blog) : sanitize(blog.item.name)}&nbsp;&nbsp;&nbsp;&nbsp;)
        end
      
      when "Forum"
        forum = comment.commentable
        is_member = false
        
        if forum.schedule        
          is_member = current_user.is_member_of?(forum.schedule.group)        
            %(#{I18n.t(:left_post_on_forum) } #{is_member ? forum_link(forum): sanitize(forum.schedule.concept)}&nbsp;&nbsp;&nbsp;&nbsp;)
        end
      else
        ""
      end      
        

    when "Match"	
          match = activity.item
          is_member = false
          
          match = activity.item
          is_member = current_user.is_member_of?(match.schedule.group)
          %(#{I18n.t(:changes_in_roster_status) } #{I18n.t(:in) } #{is_member ? team_roster_link(match.schedule) : sanitize(match.schedule.concept)}.&nbsp;&nbsp;&nbsp;&nbsp;)

    # when "Result"
    #   %(Resultados ya se han actualizado...)
      
	  when "Scorecard"
          scorecard = activity.item
          is_member = current_user.is_member_of?(scorecard.group)
      %(changed results for #{is_member ? group_link(scorecard.group) : sanitize(scorecard.group.name)}.<br/>)
            
    else
      raise "Invalid activity type #{activity_type(activity).inspect}"
    end
  end
  
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
