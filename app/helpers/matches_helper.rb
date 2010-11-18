module MatchesHelper

  def match_roster_change_link(match, type)    
    the_schedule = match.schedule
    the_image = 'status_online.png'
    the_label = the_label = "#{I18n.t(:change_roster_status) } #{I18n.t(type.name)}"

    case type.id
    when 1
      the_image = 'status_online.png'
    when 2
      the_image = 'status_away.png' 
    when 3
      the_image = 'status_busy.png' 
    when 4
      the_image = 'status_offline.png'
    end      
    link_to(image_tag(the_image, :title => the_label, :style => "height: 16px; width: 16px;"), match_status_path(:id => match.id, :type => type.id), :title => the_label)      
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

  def match_image_link(match, the_image="")    
    the_schedule = match.schedule
    # the_image = the_schedule.sport.icon
    the_label = ""
    the_label = "#{I18n.t(match.type_name)}" if the_image.blank?

    case match.type_id
    when 1
      the_image = 'status_online.png' if the_image.blank?
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 16px; width: 16px;"), team_roster_path(:id => the_schedule), :title => the_label)
    when 2
      the_image = 'status_away.png' if the_image.blank?
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_last_minute_path(:id => the_schedule), :title => the_label)
    when 3
      the_image = 'status_busy.png' if the_image.blank?
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_no_show_path(:id => the_schedule), :title => the_label)
    when 4
      the_image = 'status_offline.png' if the_image.blank?
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_unavailable_path(:id => the_schedule), :title => the_label)
    end    
  end

end

