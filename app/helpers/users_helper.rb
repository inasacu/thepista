module UsersHelper
  def link_to_user(user, options={})
    raise "Invalid user" unless user
    options.reverse_merge! :content_method => :name, :title_method => :name, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= user.send(options.delete(:content_method))
    options[:title] ||= user.send(options.delete(:title_method))
    link_to h(content_text), user_path(user), options
  end

  #
  # Link to login page using remote ip address as link content
  #
  # The :title (and thus, tooltip) is set to the IP address 
  #
  # Examples:
  #   link_to_login_with_IP
  #   # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  #
  #   link_to_login_with_IP :content_text => 'not signed in'
  #   # => <a href="/login" title="169.69.69.69">not signed in</a>
  #
  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  #
  # Link to the current user's page (using link_to_user) or to the login page
  # (using link_to_login_with_IP).
  #
  def link_to_current_user(options={})
    if current_user
      link_to_user current_user, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      # kill ignored options from link_to_user
      [:content_method, :title_method].each{|opt| options.delete(opt)} 
      link_to_login_with_IP content_text, options
    end
  end


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
  def will_receive_email(user)
    receive_email = globalite_b(user.message_notification)
    if current_user == user 
      link_to receive_email, {:controller => "users", :action => "set_email", :id => @user.id},
      :confirm => "#{t :change_message_notification } #{@user.name}?"
    else
      return receive_email
    end
  end

  # returns a link to allow user to display or hide phone
  def is_private_phone(user)
    private_phone = globalite_b(@user.message_notification)
    if current_user == user 
      link_to private_phone, {:controller => "users", :action => "set_phone", :id => @user.id},
      :confirm => "#{t :change_private_phone } #{@user.name}?"
    else
      return private_phone
    end
  end 

  # returns a link to allow user to display or hide his/her technical and physical profile
  def is_private_profile(user)
    private_profile = globalite_b(@user.message_notification)
    if current_user == user
      link_to private_profile, :controller => "users", :action => "set_profile", :id => @user.id
    else
      return private_profile
    end				
  end

  # returns a link to allow user to view openid tab
  def show_openid(user)
    display_openid = globalite_b(@user.openid_login)
    if current_user == user
      link_to display_openid, {:controller => "users", :action => "set_openid", :id => @user.id}, :confirm => "#{t :change_openid } #{@user.name}?"
    else
      return display_openid
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
      return image_link_large(user)
    end

    if user == current_user
      "#{label_name(:no_photo_for, get_the_controller)}.  #{link_to(label_name(:upload), edit_user_path(user))}"
    else
      return image_link_large(user)
    end
  end	

  def image_link_tiny(user)
    link_to(image_tag(user.avatar, options={:style => "height: 15px; width: 15px;"}), user_path(user)) 
  end

  def image_link_smaller(user)
    link_to(image_tag(user.avatar, options={:style => "height: 22px; width: 22px;"}), user_path(user)) 
  end

  def image_link_small(user)
    link_to(image_tag(user.avatar, options={:style => "height: 30px; width: 30px;"}), user_path(user))
  end

  def image_link_medium(user)
    link_to(image_tag(user.avatar, options={:style => "height: 55px; width: 55px;"}), user_path(user))
  end

  def image_link_large(user)
    link_to(image_tag(user.avatar, options={:style => "height: 80px; width: 80px;"}), user_path(user)) 
  end

  def user_list(objects)
    list_of_objects = ""
    objects.each do |object|
      list_of_objects += "#{user_link object}, "      
    end
    return list_of_objects.chop.chop
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
    # We normally write link_to(..., user) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), user, html_options)
  end

  # Same as user_link except sets up HTML needed for the image on hover effect
  def user_link_with_image(text, user = nil, html_options = nil)
    if user.nil?
      user = text
      text = user.name
    elsif user.is_a?(Hash)
      html_options = user
      user = text
      text = user.name
    end
    '<span class="imgHoverMarker">' + image_tag(user.thumbnail) + user_link(text, user, html_options) + '</span>'
  end

  def user_image_hover_text(text, user, html_options = nil)
    '<span class="imgHoverMarker">' + image_tag(user.thumbnail) + text + '</span>'
  end

  def activated_status(user)
    user.deactivated? ? "Activate" : "Deactivate"
  end

  private

  # Make captioned images.
  def captioned(images, captions)
    images.zip(captions).map do |image, caption|
      markaby do
        image << div { caption }
      end
    end
  end
end

