module MarkersHelper

  # Link to a marker (default is by name).
  def marker_link(text, item = nil, html_options = nil)
    # if marker.nil?
    #   marker = text
    #   text = marker.name
    # elsif marker.is_a?(Hash)
    #   html_options = marker
    #   marker = text
    #   text = marker.name
    # end
    # # We normally write link_to(..., marker) for brevity, but that breaks
    # 
    # link_to(h(text), marker, html_options)
    item_name_link(text, item, html_options)
  end           
end
