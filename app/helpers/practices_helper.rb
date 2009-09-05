module PracticesHelper

  # Link to a practice (default is by concept).
  def practice_link(text, practice = nil, html_options = nil)
    if practice.nil?
      practice = text
      text = practice.concept
    elsif practice.is_a?(Hash)
      html_options = practice
      practice = text
      text = practice.concept
    end
    # We normally write link_to(..., practice) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), practice, html_options)
  end               
end


