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
end

