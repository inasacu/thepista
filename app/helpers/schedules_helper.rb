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

  def view_schedule_name(schedule, show_price=false) 
    is_member_and_not_mock = (is_current_member_of(schedule.group) or schedule.public)
		is_member_and_not_mock = schedule.ismock.nil? ? is_member_and_not_mock : !schedule.ismock
    
    the_sport = ""  
    the_missing = ""
    the_concept = ""
    the_image = ""
		the_price = ""
		the_prematch_player = ""
		show_price = (Time.zone.now < schedule.starts_at) ? show_price : false
		
    # the_image = is_member_and_not_mock ? schedule_image_link_small(schedule) : schedule_image_small(schedule)

    if schedule.game_played?
      the_concept = is_member_and_not_mock ? link_to(sanitize(limit_url_length(schedule.name, 25)), schedule_path(:id => schedule)) : sanitize(limit_url_length(schedule.name))
			the_price = "#{link_to(label_name(:scorecard), scorecard_path(:id => schedule.group))}"
    else
      the_concept = is_member_and_not_mock ? link_to(sanitize(limit_url_length(schedule.name, 25)), team_roster_path(:id => schedule)) : sanitize(limit_url_length(schedule.name))

      the_sport = "#{the_font_green(label_name(:rosters))}:  #{schedule.convocados.count}"
      the_missing = ", #{the_font_yellow(I18n.t(:missing))}:  #{schedule.player_limit.to_i - schedule.convocados.count}" if schedule.player_limit.to_i > schedule.convocados.count
      the_missing = ", #{the_font_red(I18n.t(:excess))}:  #{schedule.convocados.count - schedule.player_limit.to_i}" if schedule.player_limit.to_i < schedule.convocados.count
			the_price = "<br/><STRONG>#{label_name(:fee_per_game_short)}:</STRONG> #{number_to_currency(schedule.fee_per_game)}" if show_price
    end
		
		
    the_span = set_content_tag_safe('span', "    #{the_sport} #{the_missing} #{the_price}", 'date')  
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
			the_venue = ""
			the_installation = ""
			
			if schedule.group.installation
				the_installation = schedule.group.installation
				the_venue = "#{schedule.group.venue.short_name}, #{the_installation.name}"
				the_installation_link = "#{link_to(the_venue, reservations_path(:id => the_installation))}".html_safe
				the_installation_link = "#{the_venue}".html_safe if schedule.group.is_branch?
			else
				the_installation_link =  has_left(schedule.starts_at)
			end
			
			the_span = content_tag('span', the_installation_link, :class => 'date') if Time.zone.now < schedule.starts_at
      the_score = nice_day_time_wo_year_exact(schedule.starts_at)
    end
		return set_content_tag_safe(:td, "#{the_score}<br />#{the_span}", 'name_and_date')
  end

  def view_schedule_marker(schedule)
    the_sport = ""
    the_missing = ""
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
      
      # schedule.matches.each do |match|
      schedule.matches.find(:all, :include => [:user, :type]).each do |match| 
        the_font_begin =  ""
        the_font_end = ""
				the_match_type_name_downcase = (match.type_name).downcase
				the_font=""
				is_same_user = is_current_same_as(match.user)
				
        case match.type_id
        when 1
					the_font = the_font_green(the_match_type_name_downcase)
        when 2
					the_font = the_font_yellow(the_match_type_name_downcase)
        when 3
					the_font = the_font_red(the_match_type_name_downcase)
        end
        the_label = "<STRONG>#{I18n.t(:your_roster_status)}</STRONG> #{the_font}" if is_same_user
      end
      
			the_match_link = match_all_my_link(schedule, current_user, false, true)
			
			if the_match_link.blank?

				if current_user.is_member_of?(schedule.group)
					@user = User.find(current_user)
					
					the_label = "#{I18n.t(:change_roster_status) } #{I18n.t(:convocado).downcase}"
					the_match_link = link_to(the_label, new_schedule_url(:id => schedule.group, :block_token => schedule.block_token))
					the_label = ""
					
				else
					the_group = schedule.group
					is_member_group = the_group ? is_current_member_of(the_group) : false
					show_join_option = (!is_member_group and !has_current_item_petition(the_group))
					the_match_link = set_image_and_link_h6(join_item_link_to(current_user, the_group), 'user_add') if show_join_option
				end
			end
		
      return set_content_tag_safe(:td, "#{the_label}<br/>#{the_match_link}", "last_upcoming")
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


