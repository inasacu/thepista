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
  



end


