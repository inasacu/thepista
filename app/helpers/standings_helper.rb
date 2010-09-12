module StandingsHelper

  # Link to a standing (default is by name).
  def standing_link(text, item = nil, html_options = nil)
    # if standing.nil?
    #   standing = text
    #   text = standing.name
    # elsif standing.is_a?(Hash)
    #   html_options = standing
    #   standing = text
    #   text = standing.name
    # end
    # # We normally write link_to(..., standing) for brevity, but that breaks
    # 
    # link_to(h(text), standing, html_options)
    item_name_link(text, item, html_options)
  end

end