module SchedulesHelper

  # Link to a schedule (default is by concept).
  def schedule_link(text, item = nil, html_options = nil)    
    item_concept_link(text, item, html_options)
  end 

  def team_roster_link(text, schedule = nil, html_options = nil)
    if schedule.nil?
      schedule = text
      text = schedule.concept
    elsif schedule.is_a?(Hash)
      html_options = schedule
      schedule = text
      text = schedule.concept
    end    
    link_to(h(text), team_roster_path(:id => schedule), html_options)
  end 

  def schedule_image_link_small(schedule, image="")
    image = schedule.sport.icon if image.blank?
    link_to(image_tag(image, options={:style => "height: 15px; width: 15px;"}), schedule_path(schedule))
  end    

  def schedule_image_small(schedule)
    image_tag(schedule.sport.icon, options={:style => "height: 15px; width: 15px;"})
  end  

  def schedule_image_link_roster(schedule)
    link_to(image_tag(schedule.sport.icon, options={:style => "height: 15px; width: 15px;"}), team_roster_path(:id => schedule))
  end 
  
  def view_schedule_icon(schedule)
    return content_tag('td', (current_user.is_member_of?(schedule.group) or schedule.public) ? schedule_image_link_small(schedule) : schedule_image_small(schedule))
  end

  def view_schedule_concept(schedule)      
      return content_tag('td', (current_user.is_member_of?(schedule.group) or schedule.public) ? 
            link_to(sanitize(schedule.concept), team_roster_path(:id => schedule)) : sanitize(schedule.concept)) unless schedule.game_played?
            
      return content_tag('td', (current_user.is_member_of?(schedule.group) or schedule.public) ? 
                  link_to(sanitize(schedule.concept), schedule_path(:id => schedule)) : sanitize(schedule.concept)) if schedule.game_played?
  end
	
	def view_schedule_group(schedule)
	  the_span = content_tag('span', schedule.sport.name, :class => 'date')
	  return content_tag('td', "#{item_name_link(schedule.group)}<br />#{the_span}", :class => 'name_and_date')
	end

	def view_schedule_played(schedule)
	  if schedule.game_played?
	    the_span = ""
  	  the_span = content_tag('span', has_left(schedule.starts_at), :class => 'date') if Time.zone.now < schedule.starts_at
  	  the_score = "#{item_name_link(schedule.group)}&nbsp;&nbsp;#{schedule.home_score}&nbsp;&nbsp;-&nbsp;&nbsp;#{schedule.away_score}&nbsp;&nbsp;#{link_to(sanitize(schedule.group.second_team), group_path(schedule.group))}"
    else  
			the_span = ""
  	  the_span = content_tag('span', has_left(schedule.starts_at), :class => 'date') if Time.zone.now < schedule.starts_at
  	  the_score = nice_day_time_wo_year(schedule.starts_at)
    end
    return content_tag('td', "#{the_score}<br />#{the_span}", :class => 'name_and_date')
	end
	
	def view_schedule_marker(schedule)
    the_sport = ""
    the_missing = ""
    
    unless schedule.played?
      the_sport = "#{label_name(:rosters)}:  #{schedule.convocados.count}"
      the_missing = ", #{I18n.t(:missing)}:  #{schedule.player_limit.to_i - schedule.convocados.count}" if schedule.player_limit.to_i > schedule.convocados.count
      the_missing = ", #{I18n.t(:excess)}:  #{schedule.convocados.count - schedule.player_limit.to_i}" if schedule.player_limit.to_i < schedule.convocados.count
    end
    
	  the_span = content_tag('span', "#{the_sport} #{the_missing}", :class => 'date')
	  return content_tag('td', "#{marker_link(schedule.group.marker)}<br />#{the_span}", :class => 'name_and_date')
  end

  def view_schedule_rating(schedule)
    if schedule.played?
      my_rating = ""
      my_rating = ratings_for(schedule, :show_user_rating => true, :dimension => :performance, :small => true) if current_user.is_member_of?(schedule.group)
      overall_rating = ratings_for(schedule, :static, :dimension => :performance, :small => true)
      return content_tag 'td', "#{my_rating}&nbsp;&nbsp;#{overall_rating}", :class => "last_upcoming"
      
    elsif Time.zone.now < schedule.starts_at
      @match_type = Match.get_match_type
      the_label = ""
      schedule.matches.each {|match| the_label = "#{I18n.t(:your_roster_status) } #{(match.type_name).downcase}" if match.user == current_user}
      return content_tag 'td', "#{the_label}<br/>#{match_all_my_link(schedule, @match_type, current_user, false, false)}", :class => "last_upcoming"
    end
  end
end


