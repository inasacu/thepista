# Methods added to this helper will be available to all templates in the application.
require 'digest/md5'

module ApplicationHelper

  # site name
  def app_name
    "HayPista" 
  end

  # easy and clean link_to w/ <li>
  def list_link_with_active(name, options = {}, html_options = {}, &block)
    opts = {}
    opts.merge!(:class => 'active') if current_page?(options)
    content_tag(:li, link_to(name, options, html_options, &block), opts)
  end

  def get_first_active(text='')    
    controller_action ||= "#{get_the_controller}_index"
    controller_action = text unless text.blank?
    return "first active" if "#{get_the_controller}_#{get_the_action}".gsub(' ','_') == controller_action.gsub(' ','_')
    return "first"    
  end

  def get_active(text='')
    controller_action ||= "#{get_the_controller}_index"
    controller_action = text unless text.blank?
    return "active" if "#{get_the_controller}_#{get_the_action}".gsub(' ','_') == controller_action.gsub(' ','_')
    return ""    
  end

  def get_control_first(text='')
    control ||= 'home'
    control = text unless text.blank?
    return "first active" if is_controller(control)
    return "first"    
  end

  def get_control_active(control='')
    return "active" if is_controller(control)
    return ""
  end

  # I18n.t library methods
  def field_label_name(value, text="")
    text.insert(0, '_') unless text.blank?
    return I18n.t(:"#{ value.to_s.humanize.downcase.gsub(' ','_') }#{ text }")
  end

  def label_name(value, text="")
    text.insert(0, '_') unless text.blank?
    return I18n.t(:"#{ value.to_s.downcase.gsub(' ','_') }#{ text }")
  end

  def label_with_name(value, name="", text="")
    return "#{label_name(value, text)}  #{name}"
  end

  def control_label(text="")
    text.insert(0, '_') unless text.blank?
    return I18n.t(:"#{ controller.controller_name.to_s.downcase.gsub(' ','_') }#{ text }")
  end

  def control_action_label(text="")
    text.insert(0, '_') unless text.blank?
    return I18n.t(:"#{ controller.controller_name.to_s.downcase.gsub(' ','_') }_#{ controller.action_name.to_s.downcase.gsub(' ','_') }#{ text }")
  end

  def get_collection_label(collection)
    if object_counter(collection) > 0
      return control_action_label
    end
    return control_label('no')    
  end

  def object_counter(objects)
    @counter = 0
    objects.each { |object|  @counter += 1 }
    return @counter
  end

  #   <tr>
  #   <%= content_tag 'td', label_name(:name), :class => "label" %>
  #   <%= content_tag 'td', h(@group.name), :class => get_the_action %>
  # </tr>
  def tr_td_action(label, value)
    content_tag(:tr, content_tag(:td, label_name(label), :class => "label") + content_tag(:td, h(value), :class => get_the_action))
  end

  # returns true / false if controller name passed is same is current
  def is_controller(aController)
    return (self.controller.controller_name.singularize.gsub("_", " ") == aController)
  end 

  # returns true / false if action within controller name passed is same is current
  def is_action(anAction)
    return (self.controller.action_name.singularize.gsub("_", " ") == anAction)
  end

  # returns name of current controller being used
  def get_the_controller
    return self.controller.controller_name.singularize.gsub("_", " ")
  end

  # returns name of current action being used  
  def get_the_action
    return self.controller.action_name.singularize.gsub("_", " ")
  end

  def get_controller_action
    return "#{get_the_controller}_#{get_the_action}".gsub(' ','_')
  end

  def ago(time_at)
    I18n.t(:ago, :count => time_ago_in_words(time_at).capitalize) 
  end

  def has_left(time_at)
    I18n.t(:has_left, :count => time_ago_in_words(time_at).capitalize) 
  end

  # Sábado, a las 20:30
  def nice_day_time(time_at)
    return I18n.l(time_at, :format => :day_time) unless time_at.nil?
  end

  # 20:30
  def nice_simple_time_at(time_at)
    return I18n.l(time_at, :format => :simple_time_at) unless time_at.nil?
  end

  # a las 20:30
  def nice_time_at(time_at)
    return I18n.l(time_at, :format => :time_at) unless time_at.nil?
  end

  # 12 de Junio de 2010
  def nice_full_date(time_at)
    return I18n.l(time_at, :format => :full_date) unless time_at.nil?
  end

  # Sábado, 12 de Junio de 2010 a las 20:30
  def nice_day_of_week(time_at)
    return I18n.l(time_at, :format => :day_week) unless time_at.nil?
  end

  # Sábado, 12 de Junio de 2010 a las 20:30
  def nice_weekday(time_at)
    return I18n.l(time_at, :format => :day_of_week) unless time_at.nil?
  end

  # 12 de Junio de 2010 a las 20:30
  def nice_date_hour(time_at)
    return I18n.l(time_at, :format => :date_hour) unless time_at.nil?
  end

  # translation missing: es, 2010-06-12 20:30:00 +0200
  def nice_day_date(time_at)
    return I18n.l(time_at, :format => :day_date) unless time_at.nil?
  end

  # translation missing: es, 2010-06-12 20:30:00 +0200
  def nice_day_weekday(time_at)
    return I18n.t(time_at, :format => :day_weekday) unless time_at.nil?
  end

  # 12 de Junio
  def nice_date_wo_year(time_at)
    return I18n.l(time_at, :format => :date_wo_year) unless time_at.nil?
  end

  # Sábado, 12 de Junio
  def nice_day_date_wo_year(time_at)
    return I18n.l(time_at, :format => :day_date_wo_year) unless time_at.nil?
  end

  # Sábado, 12 de Junio a las 20:30
  def nice_day_time_wo_year(time_at)
    return I18n.l(time_at, :format => :day_time_wo_year) unless time_at.nil?
  end
  
  # converts two dates and get date and time from first and second
  def convert_to_datetime(the_date, the_time)
  	the_datetime = "#{the_date.strftime('%Y%m%d')} #{nice_simple_time_at(the_time)}"
  	return DateTime.strptime(the_datetime, '%Y%m%d %H:%M')
  end

  def limit_url_length(text)
    text = h(text)
    text = "#{text.to_s.strip[0..12]}..." if text.to_s.length > 14
    text = text.gsub(" ", "<wbr> ")
    text = text.split.collect {|i| i.capitalize}.join(' ')
    return text
  end

  # def truncate(str, length)
  #   return '' if str.blank?
  #   truncated = str.size > length
  #   (str.mb_chars[0..(truncated ? length - 3 : length)] + (truncated ? "..." : '')).to_s
  # end

  def current_announcements
    unless session[:announcement_hide_time].nil?
      time = session[:announcement_hide_time]
    else
      time = cookies[:announcement_hide_time].to_datetime unless cookies[:announcement_hide_time].nil?
    end
    @current_announcements ||= Announcement.current_announcements(time)
  end

  def upcoming_schedules
    @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
  end

  def upcoming_cups
    @upcoming_cups ||= Cup.upcoming_cups(session[:cup_hide_time])
  end

  def upcoming_games
    @upcoming_games ||= Game.upcoming_games(session[:game_hide_time])
  end

  def upcoming_meets
    @upcoming_meets ||= Meet.upcoming_meets(session[:meet_hide_time])
  end

  def current_messages
    @current_messages ||= Message.current_messages(current_user)
  end

  def upcoming_classifieds
    @upcoming_classifieds ||= Classified.upcoming_classifieds(session[:classified_hide_time])
  end

  def year_range( start_year = Time.zone.now.year )
    [start_year, Time.zone.now.year].sort.uniq.join('-')
  end

  def tag_cloud( tags )          
    classes = %w(a.cloud_0 a.cloud_1 a.cloud_2 a.cloud_3 cloud_4 cloud_5 cloud_6 cloud_7 cloud_8 cloud_9 cloud_10)         
    max, min = 0, 0          
    tags.each { |t|                
      max = t.count.to_i if t.count.to_i > max                
      min = t.count.to_i if t.count.to_i < min          
    }          
    divisor = ((max - min) / classes.size) + 1          
    tags.each { |t|                 
      yield t.name, classes[(t.count.to_i - min) / divisor]          
    }  
  end

  def proper_case(text)
    text = h(text)
    text = text.split.collect {|i| i.capitalize}.join(' ') 
    return text
  end

  def page_title
    "HayPista" + ( " | " + @content_for_title if @content_for_title).to_s
  end

  def page_heading(text)
    content_tag(:h1, content_for(:title){ h(text) })
  end

  def page_description
    value = 140
    text = h(@content_for_description).to_s
    text = "#{text.to_s.strip[0..value]}..." if text.to_s.length > value
    return @content_for_description = (text.blank? ? label_name(:modo) : "#{app_name} | #{text}")
  end

  def show_heading(text)
    content_tag(:h2, h(text), :class => :title )
  end

  # Link to a item (default is by name).
  def item_name_link(text, item = nil, html_options = nil, limit = nil)
    if item.nil?
      item = text
      text = item.name
    elsif item.is_a?(Hash)
      html_options = item
      item = text
      text = item.name
    end
    text = limit_item_link_length(text, limit) unless (limit == nil)
    text = proper_case(text) if item.class.to_s == 'User'
    link_to(h(text), item, html_options)
  end

  # Link to a item (default is by concept).
  def item_concept_link(text, item = nil, html_options = nil, limit = nil)
    if item.nil?
      item = text
      text = item.concept
    elsif item.is_a?(Hash)
      html_options = item
      item = text
      text = item.concept
    end
    text = limit_item_link_length(text, limit) unless (limit == nil)
    link_to(h(text), item, html_options)
  end

  def limit_item_link_length(text, value)
    text = h(text)
    text = "#{text.to_s.strip[0..value]}..." if text.to_s.length > value
    text = text.split.collect {|i| i.capitalize}.join(' ')
    return text
  end

  def option_image_link(item, align='')
    the_image = "icons/#{item}.png"
    return image_tag(the_image, options={:style => 'height: 16px; width: 16px;', :align => align})
  end

  def option_link(item) 
    the_image = "icons/#{item}.png"
    the_label = I18n.t("create_new_#{item}")
    the_path = "new_#{item}_url"
    return link_to(the_label, send(:"#{the_path}"))
  end

  def item_image_link_tiny(item)
    the_path = "#{item.class.to_s.downcase.chomp}_path"
    link_to(image_tag(item.avatar, options={:style => "height: 15px; width: 15px;"}), send(:"#{the_path}", item)) 
  end

  def item_image_link_smaller(item)
    the_path = "#{item.class.to_s.downcase.chomp}_path"
    link_to(image_tag(item.avatar, options={:style => "height: 22px; width: 22px;"}), send(:"#{the_path}", item)) 
  end

  def item_image_link_small(item)
    the_path = "#{item.class.to_s.downcase.chomp}_path"
    link_to(image_tag(item.avatar, options={:style => "height: 30px; width: 30px;"}), send(:"#{the_path}", item))  
  end

  def item_image_name_link_small(item)
    the_path = "#{item.class.to_s.downcase.chomp}_path"
    link_to(image_tag(item.avatar, options={:style => "height: 30px; width: 30px;", :title => h(item.name)}), send(:"#{the_path}", item))
  end

  def item_image_link_medium(item)
    the_path = "#{item.class.to_s.downcase.chomp}_path"
    link_to(image_tag(item.avatar, options={:style => "height: 55px; width: 55px;"}), send(:"#{the_path}", item))   
  end

  def item_image_link_large(item)
    the_path = "#{item.class.to_s.downcase.chomp}_path"
    link_to(image_tag(item.avatar, options={:style => "height: 80px; width: 80px;"}), send(:"#{the_path}", item))  
  end 

  def item_list(items)    
    the_link = "#{items.first.class.to_s.downcase.chomp}_link"
    list_of_items = ""
    items.each do |item|
      list_of_items += send(:"#{the_link}", item)
      list_of_items += ", "      
    end
    return list_of_items.chop.chop
  end

  def item_new(item)    
    the_url = "new_#{item.class.to_s.downcase.chomp}_url"
    content_tag('li', link_to(control_action_label, send(:"#{the_url}")), :class =>  get_first_active ) if is_action('new')
  end

  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end


  def get_secondary_navigation(item=nil, game=nil)
    the_controller = is_controller('home') ? "#{get_the_controller}" : "#{get_the_controller}s"
    return render("#{the_controller}/secondary_navigation") if item.nil? 
    return render("#{(item.class.to_s).downcase}s/secondary_navigation", :item => item) if game.nil?
    return render("#{(item.class.to_s).downcase}s/secondary_navigation", :item => item, :game => game) 
  end

  def get_class_table_id_controller
    the_controller = get_the_controller.gsub(' ','_')
    "<table class='table' id='#{the_controller}'>"
  end

  def get_class_table_id_action
    the_action = get_the_action.gsub(' ','_')
    "<table class='table' id='#{the_action}'>"
  end

  def get_cluetip(the_label, image_name, the_description, icon_only=false, align='')
    the_image = option_image_link(image_name, align)
    the_title = "<strong>#{the_label}</strong>"
    the_id = "tip-#{the_label.downcase.gsub(' ','-')}-#{rand(10000)}"
    the_content = ""

    if icon_only
      the_content = content_tag(:span, the_image, :class => 'tooltip', :title => the_title, :rel => "##{the_id}")
      the_image=""
    else
      the_content = content_tag(:span, the_label, :class => 'tooltip', :title => the_title, :rel => "##{the_id}")
    end
    the_content_div = content_tag(:div, the_description, :id => the_id, :style => 'display:none')

    return "#{the_image}&nbsp;&nbsp;#{the_content} #{the_content_div}"
  end

  def get_cluetip_show(the_label, align='right')	  
    the_description = I18n.t("#{the_label}_cluetip") 
    the_label = I18n.t(the_label)
    return "#{the_label}#{get_cluetip(the_label, 'info', the_description, true, align)}"
  end

  def get_cluetip_toggle(the_label) 
    the_description = I18n.t("#{the_label}_cluetip") 
    the_label = I18n.t(the_label)  
    the_random = rand(10000)
    the_title = "<strong>#{the_label}</strong>"
    the_id = "tip-#{the_label.downcase.gsub(' ','-')}-#{the_random}"

    the_content = content_tag :h5, (content_tag(:span, the_label, :class => 'tooltip', :title => the_title, :rel => "##{the_id}"))
    the_content_div = content_tag(:div, the_description, :id => the_id, :style => 'display:none')
    the_content = "#{the_content} #{the_content_div}"    
    return the_content
  end

  # def get_cluetip_td(the_label, the_description, the_class="") 
  #   the_description = I18n.t("#{the_label}_cluetip") 
  #   the_label = I18n.t(the_label)  
  #   the_title = "<strong>#{the_label}</strong>"
  #   the_id = "tip-#{the_label.downcase.gsub(' ','-')}-#{rand(10000)}"
  # 
  #   the_content = content_tag(:span, the_label, :class => 'tooltip', :title => the_title, :rel => "##{the_id}")
  #   the_content_div = content_tag(:div, the_description, :id => the_id, :style => 'display:none')
  #   # the_content = "<td class='#{the_class}'>#{the_content} #{the_content_div}<td>"    
  #   the_content = "<td class='label'><a href='#'>#{the_content}</a>#{the_content_div}</td>"    
  #   return the_content
  # end

  def control_description(value, no_description=false)
    the_description = I18n.t(value)
    the_description = control_label("#{value}_description") unless no_description
    return "#{the_description}..."
  end

end
