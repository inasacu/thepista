module SchedulesHelper

  # Link to a schedule (default is by concept).
  def schedule_link(text, item = nil, html_options = nil)    
    item_name_link(text, item, html_options)
  end 

  def team_roster_link(text, schedule = nil, html_options = nil)
    if schedule.nil?
      schedule = text
      text = schedule.name
    elsif schedule.is_a?(Hash)
      html_options = schedule
      schedule = text
      text = schedule.name
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
      return content_tag(:td, (is_current_member_of(schedule.group) or schedule.public) ? 
              schedule_image_link_small(schedule) : schedule_image_small(schedule))
  end

  def view_schedule_name(schedule) 
    is_member = (is_current_member_of(schedule.group) or schedule.public)
    
    the_sport = ""  
    the_missing = ""
    the_concept = ""
    the_image = ""
    # the_image = is_member ? schedule_image_link_small(schedule) : schedule_image_small(schedule)

    if schedule.game_played?
      the_concept = is_member ? link_to(sanitize(limit_url_length(schedule.name, 25)), schedule_path(:id => schedule)) : sanitize(limit_url_length(schedule.name))
    else
      the_concept = is_member ? link_to(sanitize(limit_url_length(schedule.name, 25)), team_roster_path(:id => schedule)) : sanitize(limit_url_length(schedule.name))

      the_sport = "#{label_name(:rosters)}:  #{schedule.convocados.count}"
      the_missing = ", #{I18n.t(:missing)}:  #{schedule.player_limit.to_i - schedule.convocados.count}" if schedule.player_limit.to_i > schedule.convocados.count
      the_missing = ", #{I18n.t(:excess)}:  #{schedule.convocados.count - schedule.player_limit.to_i}" if schedule.player_limit.to_i < schedule.convocados.count
    end

    the_span = set_content_tag_safe('span', "    #{the_sport} #{the_missing}", 'date')  
		return set_content_tag_safe('td', "#{the_image}  #{the_concept}<br />#{the_span}", 'name_and_date')
  end

  def view_schedule_group(schedule)
    the_span = content_tag('span', schedule.sport.name, :class => 'date')
    return set_content_tag_safe(:td, "#{item_name_link(schedule.group)}<br />#{the_span}", 'name_and_date')
  end

  def view_schedule_played(schedule)
    if schedule.game_played?
      the_span = ""
      the_span = content_tag('span', nice_day_time_wo_year_exact(schedule.starts_at), :class => 'date') 
      the_score = "#{item_name_link(schedule.group)}&nbsp;&nbsp;#{schedule.home_score}&nbsp;&nbsp;-&nbsp;&nbsp;#{schedule.away_score}&nbsp;&nbsp;#{link_to(sanitize(schedule.group.second_team), group_path(schedule.group))}"
    else  
      the_span = ""
      the_span = content_tag('span', has_left(schedule.starts_at), :class => 'date') if Time.zone.now < schedule.starts_at
      the_score = nice_day_time_wo_year_exact(schedule.starts_at)
    end
		return set_content_tag_safe(:td, "#{the_score}<br />#{the_span}", 'name_and_date')
  end

  def view_schedule_marker(schedule)
    the_sport = ""
    the_missing = ""

    # unless schedule.played?
    #   the_sport = "#{label_name(:rosters)}:  #{schedule.convocados.count}"
    #   the_missing = ", #{I18n.t(:missing)}:  #{schedule.player_limit.to_i - schedule.convocados.count}" if schedule.player_limit.to_i > schedule.convocados.count
    #   the_missing = ", #{I18n.t(:excess)}:  #{schedule.convocados.count - schedule.player_limit.to_i}" if schedule.player_limit.to_i < schedule.convocados.count
    # end

    # the_span = content_tag('span', "#{the_sport} #{the_missing}".html_safe, :class => 'date')
    # return content_tag(:td, "#{marker_link(schedule.group.marker)}<br />#{the_span}".html_safe, :class => 'name_and_date')

    the_span = set_content_tag_safe('span', "#{the_sport} #{the_missing}", 'date')
    return set_content_tag_safe(:td, "#{marker_link(schedule.group.marker)}<br />#{the_span}", 'name_and_date')
  end

  def view_schedule_rating(schedule)
    if schedule.played? or Time.zone.now > schedule.starts_at
      my_rating = ""
			overall_rating = ""
      return set_content_tag_safe(:td, "#{my_rating}&nbsp;&nbsp;#{overall_rating}", "last_upcoming")

    elsif Time.zone.now < schedule.starts_at
      the_label = ""
      
      schedule.matches.each do |match| 
        the_font_begin =  ""
        the_font_end = ""

        case match.type_id
        when 1
          the_font_begin = "<font color='#0f7d00'>"
          the_font_end = "</font>"
        when 2
          the_font_begin = "<font color='#ff9933'>"
          the_font_end = "</font>"
        when 3
          the_font_begin = "<font color='#ff3300'>"
          the_font_end = "</font>"
        end
        the_label = "#{I18n.t(:your_roster_status) } #{the_font_begin}#{(match.type_name).downcase}#{the_font_end}" if is_current_same_as(match.user)
      end
      
      return set_content_tag_safe(:td, "#{the_label}<br/>#{match_all_my_link(schedule, current_user, false, true)}", "last_upcoming")
    end
  end

  def recent_activities_schedules(schedule_items)
    the_template = DISPLAY_HAYPISTA_TEMPLATE ? "home/upcoming_schedules" : "home/upcoming_schedules_zurb"
    the_activities = ""
    the_user_schedules = []
    total_items = 0
    counter = 0

    schedule_items.each {|item| total_items += 1}

    schedule_items.each do |item| 
      counter += 1

      same_previous_schedule = false														
      if the_user_schedules.empty?
        the_user_schedules << item 								
        same_previous_schedule = true

      else
        the_user_schedules.each do |the_schedule|
          same_previous_schedule = (the_schedule.group == item.group)
        end

        the_user_schedules << item if same_previous_schedule
      end

      if (same_previous_schedule and counter < total_items)
      else
        the_activities = %(#{the_activities.html_safe} #{render(the_template.html_safe, :schedules => the_user_schedules).html_safe})

        #reset the_user_match and add new match
        the_user_schedules = []
        the_user_schedules << item
      end																

    end
    return the_activities.html_safe
  end

  def upcoming_schedules(schedules)
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

    the_schedule = schedules.first
    the_group = the_schedule.group

    the_manager = the_group.all_the_managers.first
    request_image = item_image_link_small(the_manager)
    request_link = item_name_link(the_manager)

    # item_link = item_name_link(the_schedule)
    item_image = item_image_link_small(the_group)	
    item_group_link = item_name_link(the_group)

    the_icon = schedule_image_link_small(the_schedule, IMAGE_CALENDAR)

    is_member = is_current_member_of(the_group)
    if the_schedule.played?
      the_label = %(#{I18n.t(:has_updated_scorecard) } #{the_label} )
    else
      the_label = %(#{I18n.t(:created_a_schedule) } )
    end

    the_links = ""	
    schedules.each do |schedule|
      the_links = %(#{the_links} #{is_member ? item_name_link(schedule) : sanitize(schedule.name)}, )
    end

    the_links = %(#{the_links.chop.chop})	
    the_label = %(#{the_label} #{the_links})

    return request_image, first_icon, request_link, the_label, the_icon, item_group_link, item_group_link, the_schedule
  end

  def get_team_roster
    the_label = "#{control_action_label("#{@has_a_roster}")} #{label_name(:in)} #{sanitize(@schedule.name)} (#{h(@schedule.group.name)})"

    the_content = content_for(:title, sanitize(@schedule.name))

    has_been_played = @schedule.played? 
    is_manager = is_current_manager_of(@schedule.group)
    is_squad = get_the_action.gsub(' ','_') == 'team_roster'

    the_sport = ""
    the_missing = ""

    unless @schedule.played?
      the_sport = "#{label_name(:rosters)}:  #{@schedule.convocados.count}"
      the_missing = ", #{I18n.t(:missing)}:  #{@schedule.player_limit.to_i - @schedule.convocados.count}" if @schedule.player_limit.to_i > @schedule.convocados.count
      the_missing = ", #{I18n.t(:excess)}:  #{@schedule.convocados.count - @schedule.player_limit.to_i}" if @schedule.player_limit.to_i < @schedule.convocados.count
    end

    the_span = "#{the_sport} #{the_missing}"

    the_start_at_label = "#{nice_day_time_wo_year_exact(@schedule.starts_at)}<br/>#{the_span}"
    the_start_at_label = "#{the_start_at_label}#{get_cluetip(label_name(:schedule_excess_player), nil, 
    label_name('schedule_excess_player_cluetip'), true)}" if (@the_roster.count > @schedule.player_limit and is_squad)
    
    return the_label, the_content, has_been_played, is_manager, is_squad, the_sport, the_missing, the_span, the_start_at_label 
  end
  
end


