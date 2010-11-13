module MessagesHelper

  def list_link_with_active(name, options = {}, html_options = {}, &block)
    opts = {}
    opts.merge!(:class => "active") if current_page?(options)
    content_tag(:li, link_to(name, options, html_options, &block), opts)
  end

  def message_icon(message)
    if message.new?(current_user)
      image_tag("icons/email_add.png", :class => "icon")
    elsif message.replied_to?
      image_tag("icons/email_go.png", :class => "icon")
    end
  end

  def message_anchor(message)
    "message_#{message.id}"
  end

  def message_image_link(message)    
    the_image = 'icons/email_delete.png' 
    the_label = label_name(:message_delete)
    # the_confirmation =  %(#{the_label}?)
    link_to(image_tag(the_image, :title => the_label, :style => "height: 16px; width: 16px;"), message_path(message), :method => :delete, :title => the_label)
  end											
end