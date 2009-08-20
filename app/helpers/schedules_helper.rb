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
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), schedule, html_options)
  end               
end


