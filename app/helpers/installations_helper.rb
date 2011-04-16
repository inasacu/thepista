module InstallationsHelper

  def installation_image_link_small(installation, image="")
    image = installation.sport.icon if image.blank?
    link_to(image_tag(image, options={:style => "height: 15px; width: 15px;"}), installation_path(installation))
  end    

  def installation_image_small(installation)
    image_tag(installation.sport.icon, options={:style => "height: 15px; width: 15px;"})
  end  

  def installation_image_link_roster(installation)
    link_to(image_tag(installation.sport.icon, options={:style => "height: 15px; width: 15px;"}), team_roster_path(:id => installation))
  end 

  def view_installation_name(installation)      
    return content_tag('td', (current_user.is_member_of?(installation.venue) or installation.public) ? 
    link_to(sanitize(installation.name), installation_path(:id => installation)) : sanitize(installation.name))
  end

  def view_installation_venue(installation)
    the_span = content_tag('span', installation.sport.name, :class => 'date')
    return content_tag('td', "#{item_name_link(installation.venue)}<br />#{the_span}", :class => 'name_and_date')
  end

  def view_installation_times(installation)
      the_time = "#{nice_simple_time_at(installation.starts_at)} - #{nice_simple_time_at(installation.ends_at)}"
    return content_tag('td', the_time, :class => 'name_and_date')
  end


  def view_installation_marker(installation)
    the_sport = ""
    the_span = content_tag('span', the_sport, :class => 'date')
    return content_tag('td', "#{marker_link(installation.marker)}<br />#{the_span}", :class => 'name_and_date')
  end

  def view_installation_icon(installation)
    return content_tag('td', (current_user.is_member_of?(installation.venue) or installation.public) ? installation_image_link_small(installation) : installation_image_small(installation))
  end

end


