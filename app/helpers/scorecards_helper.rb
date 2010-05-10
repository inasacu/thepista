module ScorecardsHelper
  
  # Link to a scorecard (default is by name).
  def scorecard_link(text, scorecard = nil, html_options = nil)
    if scorecard.nil?
      scorecard = text
      text = scorecard.name
    elsif scorecard.is_a?(Hash)
      html_options = scorecard
      scorecard = text
      text = scorecard.name
    end
    # We normally write link_to(..., scorecard) for brevity, but that breaks
    
    link_to(h(text), scorecard, html_options)
  end
  
end