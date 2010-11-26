module ScorecardsHelper
  def scorecard_link(text, item = nil, html_options = nil)
    item_name_link(text, item, html_options)
  end

  def scorecard_image_link(image)    
    image_tag(image, :style => "height: 16px; width: 16px;")
  end
end