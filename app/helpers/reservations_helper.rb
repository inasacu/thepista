module ReservationsHelper

  def reservation_image_link_small(reservation, image="")
    image = reservation.sport.icon if image.blank?
    link_to(image_tag(image, options={:style => "height: 15px; width: 15px;"}), reservation_path(reservation))
  end    

  def reservation_image_small(reservation)
    image_tag(reservation.sport.icon, options={:style => "height: 15px; width: 15px;"})
  end  

  def reservation_image_link_roster(reservation)
    link_to(image_tag(reservation.sport.icon, options={:style => "height: 15px; width: 15px;"}), team_roster_path(:id => reservation))
  end 

  def view_reservation_concept(reservation)      
    return content_tag('td', (current_user.is_member_of?(reservation.venue) or reservation.public) ? 
    link_to(sanitize(reservation.concept), reservation_path(:id => reservation)) : sanitize(reservation.concept))
  end

  def view_reservation_venue(reservation)
    the_span = content_tag('span', reservation.installation.sport.name, :class => 'date')
    return content_tag('td', "#{item_name_link(reservation.venue)}<br />#{the_span}", :class => 'name_and_date')
  end

  def view_reservation_times(reservation)
    the_time = "#{nice_simple_time_at(reservation.starts_at)} - #{nice_simple_time_at(reservation.ends_at)}"
    return content_tag('td', the_time, :class => 'name_and_date')
  end

  def view_reservation_installation(reservation)
    the_installation = ""
    the_span = content_tag('span', the_installation, :class => 'date')
    return content_tag('td', "#{item_name_link(reservation.installation)}<br />#{the_span}", :class => 'name_and_date')
  end

  def view_reservation_icon(reservation)
    return content_tag('td', (current_user.is_member_of?(reservation.venue) or reservation.public) ? reservation_image_link_small(reservation.installation) : reservation_image_small(reservation.installation))
  end
  
  def view_reservation_played(reservation)
    the_span = ""
    the_span = content_tag('span', nice_day_time_wo_year(reservation.ends_at), :class => 'date') 
    the_score = nice_day_time_wo_year(reservation.starts_at)
    return content_tag('td', "#{the_score}<br />#{the_span}", :class => 'name_and_date')
  end
  
   def view_reservation_marker(reservation)
     the_installation = reservation.installation
     the_span = content_tag('span', h(the_installation.name), :class => 'date')
     return content_tag('td', "#{marker_link(the_installation.marker)}<br />#{the_span}", :class => 'name_and_date')
   end
   
end


