module ClassifiedsHelper  
  
  # Link to a classified (default is by name).
  def classified_link(text, item = nil, html_options = nil)
    item_name_link(text, item, html_options)
  end
  
  # def classified_icon(classified)
  #     image_tag("icons/email_add.png", :class => "icon")
  # end
  
  def classified_image_link(classified)    
    the_image = 'icons/comment_delete.png' 
    the_label = label_name(:classified_delete)
    # the_confirmation =  %(#{the_label}?)
    link_to(image_tag(the_image, :title => the_label, :style => "height: 16px; width: 16px;"), classified_path(classified), :method => :delete, :title => the_label)
  end
  
  

  def classified_image_link_small(classified, image="")
    link_to(image_tag(image, options={:style => "height: 15px; width: 15px;"}), classified_path(classified))
  end
end
