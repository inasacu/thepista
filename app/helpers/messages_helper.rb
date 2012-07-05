module MessagesHelper

  def list_link_with_active(name, options = {}, html_options = {}, &block)
    opts = {}
    opts.merge!(:class => "active") if current_page?(options)
    content_tag(:li, link_to(name, options, html_options, &block), opts)
  end

  def message_icon(message)
    if message.new?(current_user)
      image_tag(IMAGE_EMAIL_ADD, :style => "height: 16px; width: 16px;", :class => "icon")
    elsif message.replied_to?
      image_tag(IMAGE_EMAIL_GO, :style => "height: 16px; width: 16px;", :class => "icon")
    end
  end

  def message_anchor(message)
    "message_#{message.id}"
  end

  def message_image_link(message)    
    the_image = IMAGE_EMAIL_DELETE 
    the_label = label_name(:message_delete)
    # the_confirmation =  %(#{the_label}?)
    link_to(image_tag(the_image, :title => the_label, :style => "height: 16px; width: 16px;"), message_path(message), :method => :delete, :title => the_label)
  end		

  # def message_link_to(item, extend_image=true)
  #   the_image = ""
  #   the_image = "#{option_image_link('message')}  " if extend_image
  #   return " #{the_image}#{link_to(label_name(:send_message_to), new_message_path(:item_id => item))}"
  # end 								
end