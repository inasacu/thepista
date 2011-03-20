module MatchesHelper

  def match_roster_change_link(match, type, show_label=true, show_icon=true)    
    the_schedule = match.schedule
    the_image = 'estatus-convocado.png'

    the_label = "#{I18n.t(:change_roster_status) } #{I18n.t(type.name).downcase}"
    the_link = show_label ? "" : link_to(the_label, match_status_path(:id => match.id, :type => type.id)) 
    the_break = (show_label ? "" : "<br/>")

    case type.id
    when 1
      the_image = 'estatus-convocado.png'
    when 2
      the_image = 'estatus-ultima-hora.png' 
    when 3
      the_image = 'estatus-ausente.png' 
    when 4
      the_image = 'estatus-no-disponible.png'
    end      
    return "#{link_to(image_tag(the_image, :title => the_label, :style => 'height: 16px; width: 16px;'), 
                    match_status_path(:id => match.id, :type => type.id), :title => the_label)} #{the_link} #{the_break}" if show_icon
    return "#{the_link} #{the_break}" unless show_icon
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
      the_image = 'estatus-convocado.png' if the_image.blank?
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 16px; width: 16px;"), team_roster_path(:id => the_schedule), :title => the_label)
    when 2
      the_image = 'estatus-ultima-hora.png' if the_image.blank?
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_last_minute_path(:id => the_schedule), :title => the_label)
    when 3
      the_image = 'estatus-ausente.png' if the_image.blank?
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_no_show_path(:id => the_schedule), :title => the_label)
    when 4
      the_image = 'estatus-no-disponible.png' if the_image.blank?
      return link_to(image_tag(the_image, :title => the_label, :style => "height: 15px; width: 15px;"), team_unavailable_path(:id => the_schedule), :title => the_label)
    end    
  end
  
  def match_my_current_link(schedule, match_type, user)

    unless schedule.played?
      my_current_match = ''
      the_match_type = ''	

      schedule.matches.each{|match| my_current_match = match if match.user_id == user.id}
      match_type.each {|type| the_match_type = type if type.id == my_current_match.type_id}		
      the_current_label = "#{I18n.t(:change)} #{I18n.t(:from)} #{I18n.t(the_match_type.name).downcase}"

      the_action = get_the_action.downcase.gsub(' ','_')

      case the_match_type.id
      when 1
        show_link = (the_action == "team_roster")
      when 2
        show_link = (the_action == "team_last_minute")
      when 3
        show_link = (the_action == "team_no_show")
      when 4
        show_link = (the_action == "team unavailable")
      end

      return match_roster_link(the_current_label, my_current_match) unless show_link
    end
  end
  
  def match_all_my_link(schedule, user, is_manager, show_icon=true)
    match_types = Match.get_match_type
    
    unless schedule.played?
      my_current_match = nil
      the_match_link = ''
      schedule.matches.each{|match| my_current_match = match if match.user_id == user.id}

      unless my_current_match.nil?
        match_types.each do |type| 
          unless type.id == my_current_match.type_id 	          
            if type.id == 4
              the_match_link = "#{the_match_link} #{match_roster_change_link(my_current_match, type, is_manager)}  "  if is_manager
            else
              the_match_link = "#{the_match_link} #{match_roster_change_link(my_current_match, type, is_manager, show_icon)}  " 
            end
          end
        end
        return the_match_link
      end
    end
  end
  
end

