module MeetsHelper

  # Link to a meet (default is by concept).
  def meet_link(text, meet = nil, html_options = nil)
    if meet.nil?
      meet = text
      text = meet.concept
    elsif meet.is_a?(Hash)
      html_options = meet
      meet = text
      text = meet.concept
    end
    # We normally write link_to(..., meet) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), meet, html_options)
  end  

  def meet_image_link_small(meet)
    link_to(image_tag(meet.sport.icon, options={:style => "height: 15px; width: 15px;"}), meet_path(meet))
  end    

  def meet_image_small(meet)
    image_tag(meet.sport.icon, options={:style => "height: 15px; width: 15px;"})
  end

end



