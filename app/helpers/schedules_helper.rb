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

  def schedule_image_link_small(schedule)
    link_to(image_tag(schedule.sport.icon, options={:style => "height: 15px; width: 15px;"}), schedule_path(schedule))
  end    

  def schedule_image_small(schedule)
    image_tag(schedule.sport.icon, options={:style => "height: 15px; width: 15px;"})
  end  

  def schedule_image_link_roster(schedule)
    link_to(image_tag(schedule.sport.icon, options={:style => "height: 15px; width: 15px;"}), team_roster_path(:id => schedule))
  end 
  
  def match_roster_link(text, match = nil, html_options = nil)
    if match.nil?
      match = text
      text = match.schedule.concept
    elsif match.schedule.is_a?(Hash)
      html_options = match.schedule
      match = text
      text = match.schedule.concept
    end
        
    case match.type_id
    when 1
      return link_to(h(text), team_roster_path(:id => match.schedule), html_options)
    when 2
        return link_to(h(text), team_last_minute_path(:id => match.schedule), html_options)
    when 3
        return link_to(h(text), team_no_show_path(:id => match.schedule), html_options)
    when 4
        return link_to(h(text), team_unavailable_path(:id => match.schedule), html_options)
    end    
  end
  
  def match_image_link_roster(match)
    
    the_schedule = match.schedule
    the_image = the_schedule.sport.icon
    the_label = "#{I18n.t(match.type_name)}"
    
    case match.type_id
    when 1
      the_image = 'status_online.png'
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 16px; width: 16px;"), team_roster_path(:id => the_schedule), :title => the_label)
    when 2
      the_image = 'status_away.png' 
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_last_minute_path(:id => the_schedule), :title => the_label)
    when 3
      the_image = 'status_busy.png' 
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_no_show_path(:id => the_schedule), :title => the_label)
    when 4
      the_image = 'status_offline.png'
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_unavailable_path(:id => the_schedule), :title => the_label)
    end    
  end


end


