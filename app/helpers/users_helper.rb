module UsersHelper

  # returns a link if user can modify availability
  # this option can remove the user from the roster list
  def is_available(user)
    available = globalite_b(user.available)
    if current_user == user or user.my_managers(current_user)
      link_to available, {:controller => "users", :action => "set_available", :id => user.id}, :confirm => "#{t :change_available } #{user.name}?"
    else
      return available
    end
  end 

  # returns a link to allow a user to modify if he/she wishes to receive emails
  # def will_receive_email(user)
  #   receive_email = globalite_b(user.message_notification)
  #   if current_user == user 
  #     link_to receive_email, {:controller => "users", :action => "set_email", :id => @user.id},
  #     :confirm => "#{t :change_message_notification } #{@user.name}?"
  #   else
  #     return receive_email
  #   end
  # end

  # returns a link to allow user to display or hide phone
  # def is_private_phone(user)
  #   private_phone = globalite_b(@user.message_notification)
  #   if current_user == user 
  #     link_to private_phone, {:controller => "users", :action => "set_phone", :id => @user.id},
  #     :confirm => "#{t :change_private_phone } #{@user.name}?"
  #   else
  #     return private_phone
  #   end
  # end 

  # returns a link to allow user to display or hide his/her technical and physical profile
  # def is_private_profile(user)
  #   private_profile = globalite_b(@user.message_notification)
  #   if current_user == user
  #     link_to private_profile, :controller => "users", :action => "set_profile", :id => @user.id
  #   else
  #     return private_profile
  #   end       
  # end

  # returns a link to allow user to view openid tab
  # def show_openid(user)
  #   display_openid = globalite_b(@user.openid_login)
  #   if current_user == user
  #     link_to display_openid, {:controller => "users", :action => "set_openid", :id => @user.id}, :confirm => "#{t :change_openid } #{@user.name}?"
  #   else
  #     return display_openid
  #   end     
  # end


  #########################
  # Return a user's image link.
  # The default is to display the user's icon linked to the profile.
  def image_link(user, options = {})
    link = options[:link] || user
    image = options[:image] || :icon
    image_options = { :title => h(user.name), :alt => h(user.name) }
    unless options[:image_options].nil?
      image_options.merge!(options[:image_options]) 
    end
    link_options =  { :title => h(user.name) }
    unless options[:link_options].nil?                    
      link_options.merge!(options[:link_options])
    end
    content = image_tag(user.send(image), image_options)
    # This is a hack needed for the way the designer handled rastered images
    # (with a 'vcard' class).
    if options[:vcard]
      # content = %(#{content}#{content_tag(:span, h(user.name), :class => "fn" )})
      content = %(#{content}#{content_tag(:span)})
    end
    link_to(content, link, link_options)
  end

  def user_show_photo(user, current_user)
    if user.photo_file_name
      return item_image_link_large(user)
    end

    if user == current_user
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_user_path(user))}"
    else
      return item_image_link_large(user)
    end
  end	

  def image_link_smaller(user)
    link_to(image_tag(user.avatar, options={:style => "height: 22px; width: 22px;"}), user_path(user)) 
  end

  def image_link_small(user)
    link_to(image_tag(user.avatar, options={:style => "height: 30px; width: 30px;", :title => h(user.name)}), user_path(user))
  end
  
  def image_link_class(user, the_class='')
    link_to(image_tag(user.avatar, options={:class => the_class, :alt => user.name, :title => user.name}), user_path(user)) 
  end

  def user_list(objects)
    # list_of_objects = ""
    # objects.each do |object|
    #   list_of_objects += "#{user_link object}, "      
    # end
    # return list_of_objects.chop.chop
    return item_list(objects)
  end
  
  def user_link_limit(text, user = nil, html_options = nil)
      if user.nil?
        user = text
        text = user.name
      elsif user.is_a?(Hash)
        html_options = user
        user = text
        text = user.name
      end
      
      # limit name length
      text = limit_url_length(text)      
      link_to(text, user, html_options)
  end

  # Link to a user (default is by name).
  def user_link(text, user = nil, html_options = nil)
    if user.nil?
      user = text
      text = user.name
    elsif user.is_a?(Hash)
      html_options = user
      user = text
      text = user.name
    end

    text = h(text)
    text = text.gsub(" ", "<wbr> ")
    text = text.split.collect {|i| i.capitalize}.join(' ')
    
    link_to(text, user, html_options)
  end

  # # Same as user_link except sets up HTML needed for the image on hover effect
  # def user_link_with_image(text, user = nil, html_options = nil)
  #   if user.nil?
  #     user = text
  #     text = user.name
  #   elsif user.is_a?(Hash)
  #     html_options = user
  #     user = text
  #     text = user.name
  #   end
  #   '<span class="imgHoverMarker">' + image_tag(user.thumbnail) + user_link(text, user, html_options) + '</span>'
  # end
  # 
  # def user_image_hover_text(text, user, html_options = nil)
  #   '<span class="imgHoverMarker">' + image_tag(user.thumbnail) + text + '</span>'
  # end

  # def activated_status(user)
  #   user.deactivated? ? "Activate" : "Deactivate"
  # end

  # private
  # 
  # # Make captioned images.
  # def captioned(images, captions)
  #   images.zip(captions).map do |image, caption|
  #     markaby do
  #       image << div { caption }
  #     end
  #   end
  # end
  
end

