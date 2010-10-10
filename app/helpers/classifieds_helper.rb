module ClassifiedsHelper  
  
  # Link to a classified (default is by name).
  def classified_link(text, item = nil, html_options = nil)
    # if classified.nil?
    #   classified = text
    #   text = classified.concept
    # elsif classified.is_a?(Hash)
    #   html_options = classified
    #   classified = text
    #   text = classified.concept
    # end
    # # We normally write link_to(..., classified) for brevity, but that breaks
    # 
    # link_to(h(text), classified, html_options)
    item_concept_link(text, item, html_options)
  end
  
  def classified_icon(classified)
      image_tag("icons/email_add.png", :class => "icon")
  end
end
