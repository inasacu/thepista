module HomeHelper
  
  def upcoming_home(teammate)
  	the_manager = nil
  	request_image = ""
  	request_link = ""

  	item_link = ""
  	item_image = ""

  	item_group_link = ""

  	the_label = ""
  	four_spaces = ".&nbsp;&nbsp;&nbsp;&nbsp;"

  	first_icon = ""
  	the_icon = ""
  	
  	the_google_plus_one = ""

  	case teammate.class.to_s
  	when "Schedule"
  		the_manager = teammate.group.all_the_managers.first
  		request_image = item_image_link_small(the_manager)
  		request_link = item_name_link(the_manager)

  		the_google_plus_one = "<g:plusone size=\"small\" count=\"true\" href=\"#{item_concept_link(teammate)}\"></g:plusone>" if DISPLAY_GOOGLE_PLUS

  		item_link = item_concept_link(teammate)
  		item_image = item_image_link_small(teammate.group)

  		item_group_link = item_name_link(teammate.group)

  		the_icon = schedule_image_link_small(teammate, "calendario.png")

  		is_member = current_user.is_member_of?(teammate.group)
  		if teammate.played?
  			the_label = %(#{I18n.t(:has_updated_scorecard) } #{the_label} #{is_member ? item_link : sanitize(teammate.concept)}#{the_google_plus_one})
  		else
  			the_label = %(#{I18n.t(:created_a_schedule) } #{the_label} #{is_member ? item_link : sanitize(teammate.concept)})
  		end

  	when "Group", "Cup", "Challenge"
  		the_manager = teammate.all_the_managers.first
  		request_image = item_image_link_small(the_manager)
  		request_link = item_name_link(the_manager)

  		item_link = item_name_link(teammate)
  		item_image = item_image_link_small(the_manager)

  		the_icon = group_avatar_image_link(teammate) if teammate.class.to_s == "Group"
  		the_icon = challenge_avatar_image_link(teammate) if teammate.class.to_s == "Challenge"
  		the_icon = cup_avatar_image_link(teammate) if teammate.class.to_s == "Cup"

  		the_label = label_name(:"updated_a_#{teammate.class.to_s.downcase}") + " <wbr/> #{item_link}" 

  	when "Reservation"
  		case teammate.item_type
        	when "User"
  			user = teammate.item
  			request_image = item_image_link_small(user)
  			request_link = item_name_link(user)

  			item_link = link_to(h(teammate.venue.name), reservations_path(:id => teammate.installation))
  			item_image = item_image_link_small(teammate.venue)

  			the_icon = reservation_avatar_image_link(teammate)
  		when ""
  		end

  		the_label = "#{label_name(:created_a_reservation)} <wbr/> #{item_link}"

  	when "Venue"
  		the_manager = teammate.all_the_managers.first
  		request_image = item_image_link_small(the_manager)
  		request_link = item_name_link(the_manager)

  		item_link = item_name_link(teammate)
  		item_image = item_image_link_small(teammate)

  		the_icon = venue_avatar_image_link(teammate)

  		the_label = "#{label_name(:created_a_venue)} <wbr/> #{item_link}"

  	when "Game"
  		the_manager = teammate.cup.all_the_managers.first
  		request_image = item_image_link_small(the_manager)
  		request_link = item_name_link(the_manager)

  		item_link = item_name_link(teammate.cup)
  		item_image = item_image_link_small(teammate.cup)

  		the_label = "#{label_name(:created_a_match)} <wbr/> #{item_link}"

  	when "Classified"

  			case teammate.table_type
  	      	when "Group"
  	        	group = teammate.table
  				the_manager = group.all_the_managers.first
  				request_image = item_image_link_small(the_manager)
  				request_link = item_name_link(the_manager)

  				item_link = item_concept_link(teammate)
  				item_image = item_image_link_small(group)

  				item_group_link = item_name_link(group)

  				the_icon = group_avatar_image_link(teammate) if teammate.class.to_s == "Group"
  				the_icon = classified_image_link_small(teammate, "icons/anuncio-deportivo.png")
  			end

  	when "User"
  		request_image = item_image_link_small(teammate)
  		request_link = item_name_link(teammate)

  		item_link = item_name_link(teammate)
  		item_image = item_image_link_small(teammate)

  		the_icon = user_avatar_image_link(teammate)

  		the_label = "#{label_name(:changed_description)}"

  	when "Scorecard"
  		request_image = item_image_link_small(teammate.user)
  		request_link = item_name_link(teammate.user)

  		# item_link = item_name_link(teammate.group)
  		# item_image = item_image_link_small(teammate.group)

  		item_group_link = item_name_link(teammate.group)

  		the_icon = user_avatar_image_link(teammate.user)

  		the_label = "#{label_name(:created_a_available)}"

  	when "Match"
  		request_image = item_image_link_small(teammate.user)
  		request_link = item_name_link(teammate.user)

  		first_icon = match_image_link(teammate)
  		the_icon = match_image_link(teammate, teammate.schedule.sport.icon)

  		item_group_link = item_name_link(teammate.schedule.group)

          is_member = current_user.is_member_of?(teammate.schedule.group)
  		the_label = %(#{I18n.t(:passed_to)} <STRONG>#{teammate.type_name}</STRONG> #{I18n.t(:in)} #{is_member ? match_roster_link(teammate) : sanitize(teammate.schedule.concept)})

      when "Comment"
  		request_image = item_image_link_small(teammate.user)
  		request_link = item_name_link(teammate.user)
  		the_label = teammate.commentable_type

        	case teammate.commentable_type
        	when "Blog"
          	blog = teammate.commentable
  			the_icon = comment_image_link_small(blog)

          	case blog.item_type
          	when "User"
  				the_user = blog.item
  	          	is_member = current_user.is_user_member_of?(the_user)
              	the_label = %(#{I18n.t(:left_comment_on_wall)}  #{is_member ? blog_link_item(blog) : sanitize(blog.item.name)})
          	when "Group", "Challenge"
            		is_member = current_user.is_member_of?(blog.item)
            		the_label = %(#{I18n.t(:left_post_on_forum)}  #{is_member ? blog_link_item(blog) : sanitize(blog.item.name)})
          	when "Venue"
            		the_label = %(#{I18n.t(:left_post_on_forum)}  #{blog_link_item(blog)})
          	end

  		when "Forum"
  		    forum = teammate.commentable
  			  the_icon = comment_image_link_small(forum)

  		    if forum.schedule        
  		      	is_member = current_user.is_member_of?(forum.schedule.group)  
  				    item_group_link = item_name_link(forum.schedule.group)

  		        the_label = %(#{I18n.t(:left_post_on_forum) } #{is_member ? forum_link(forum): sanitize(forum.schedule.concept)})
  		        if teammate.title == 'Schedule'
                the_label = %(#{I18n.t(:left_post_teams_on_forum) } #{is_member ? forum_link(forum): sanitize(forum.schedule.concept)})
              end
              
  		    end

  		end
  	end

  	the_label = label_name(:"created_a_#{teammate.class.to_s.downcase}") + " <wbr/> #{item_link}" if the_label == ""

  	return request_image, first_icon,  request_link,  the_label, the_icon, item_group_link
  end
end
