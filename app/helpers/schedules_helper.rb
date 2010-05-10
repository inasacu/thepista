module SchedulesHelper

  # Link to a schedule (default is by concept).
  def schedule_link(text, schedule = nil, html_options = nil)
    if schedule.nil?
      schedule = text
      text = schedule.concept
    elsif schedule.is_a?(Hash)
      html_options = schedule
      schedule = text
      text = schedule.concept
    end
    # We normally write link_to(..., schedule) for brevity, but that breaks
    
    link_to(h(text), schedule, html_options)
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
    # We normally write link_to(..., schedule) for brevity, but that breaks
    
    link_to(h(text), team_roster_path(:id => schedule), html_options)
  end 
  
  def schedule_image_link_small(schedule)
    link_to(image_tag(schedule.sport.icon, options={:style => "height: 15px; width: 15px;"}), schedule_path(schedule))
  end    
  
  def schedule_image_small(schedule)
    image_tag(schedule.sport.icon, options={:style => "height: 15px; width: 15px;"})
  end
  
             
end


