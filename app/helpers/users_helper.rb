module UsersHelper

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

    if is_current_same_as(user)
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_user_path(user))}"
    else
      return item_image_link_large(user)
    end
  end	

  def subscription_image_link(user, is_subscriber=false, the_label="")
    star_image = "icons/star_#{is_subscriber}.png"
    link_to(image_tag(star_image, options={:title => the_label, :style => "height: 15px; width: 15px;"}), user_path(user))
  end

  def user_avatar_image_link(user)
    link_to(image_tag(IMAGE_AVATAR, options={:style => "height: 15px; width: 15px;"}), user_path(user)) 
  end

  def image_link_tiny(user)
    link_to(image_tag(user.avatar, options={:style => "height: 20px; width: 20px;"}), user_path(user)) 
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

  # def user_list(objects)
  #   return item_list(objects)
  # end

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
    text = proper_case(text)
    text = limit_url_length(text)      
    link_to(text.html_safe, user, html_options)
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

    link_to(text.html_safe, user, html_options)
  end

  def petition_box(teammate)
    
    has_sub_item = teammate.sub_item.nil?

    is_manager = false
    can_decline = false 

    is_manager = is_current_manager_of(teammate.item) 
    can_decline = is_current_same_as(teammate.user)

    if teammate.item.class.to_s == 'Group' and teammate.item.automatic_petition 
      is_manager = false
      can_decline = false
    end

		if teammate.item.class.to_s == 'Challenge' and teammate.item.automatic_petition 
			is_manager = false
			can_decline = false
		end

    manager_link = ""
    manager_link = "#{link_to(label_name(:petition_join_item_accept), join_item_accept_path(teammate))}".html_safe if is_manager

    decline_link = ""
    decline_link = "#{link_to label_name(:petition_join_item_decline), join_item_decline_path(teammate)}".html_safe if can_decline

    request_image = item_image_link_small(teammate.user)
    request_link = item_name_link(teammate.user)

    item_link = item_name_link(teammate.item)
    item_image = item_image_link_small(teammate.item)

    sub_item_link = has_sub_item ?  "" : item_name_link(teammate.sub_item) 
    sub_item_image = has_sub_item ? "" : item_image_link_small(teammate.sub_item)


    has_joined ||= false
    has_joined = (teammate.status == 'accepted')
    the_icon = group_avatar_image_link(teammate.item) 
    the_icon = challenge_avatar_image_link(teammate.item) if teammate.item.class.to_s == 'Challenge'

    return has_sub_item, request_image, sub_item_image, request_link, has_joined, item_link, has_sub_item, sub_item_link, the_icon, has_joined, manager_link, decline_link, is_manager, can_decline
  end
end

