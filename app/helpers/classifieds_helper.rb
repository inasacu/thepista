module ClassifiedsHelper  
  
  # Link to a classified (default is by name).
  def classified_link(text, item = nil, html_options = nil)
    item_concept_link(text, item, html_options)
  end
  
  def classified_icon(classified)
      image_tag("icons/email_add.png", :class => "icon")
  end
end
