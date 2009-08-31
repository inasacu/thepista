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
    if count_objects(collection) > 0
      return control_action_label
    end
    return control_label('no')    
  end
  
  def count_objects(objects)
    @counter = 0
    objects.each { |object|  @counter += 1 }
    return @counter
  end
  
  ############################### original source
  # 
  #   
  # 
  # # include WillPaginate::ViewHelpers
  # 
  # def rpx_token_sessions_url
  #   url_for :controller => :rpx, :action => :login, :only_path => false
  # end
  # 
  # def site_logout_url
  #     url_for :controller => :site, :action => :logout
  # end
  # 
  # def site_url
  #   url_for :controller => :site, :action => :index
  # end
  # 
  # def widget_url
  #   BASE_URL + '/openid/v2/widget'
  # end
  # 
  # # def will_paginate_with_i18n(collection, options = {}) 
  # #   will_paginate_without_i18n(collection, options.merge(:previous_label => I18n.t(:previous), :next_label => I18n.t(:next))) 
  # # end 
  # # alias_method_chain :will_paginate, :i18n
  # 
  # 
  # # Translated will_paginate
  # def will_paginate_t(collection = nil, options = {})
  #   will_paginate collection, {:previous_label =>I18n.t'will_paginate_previous'), :next_label =>I18n.t'will_paginate_next')}.merge(options)
  # end

  
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
  
  # # return spaces to separate info on the site
  # def view_spaces(value=2)
  #   spaces = ""
  #   value.times{ spaces += '&nbsp;' }
  #   return spaces
  # end
 

 
  # def send_individual_email(id)
  #   return link_to(t(:send_message), :controller => 'messages', :action => 'new', :id => id)
  # end
  # 
  # def count_objects(objects)
  #   @counter = 0
  #   objects.each { |object|  @counter += 1 }
  #   return @counter
  # end
  # 
  # # send the object to this method and it will return a list of objects w/ link and commas
  # def list_objects(objects)
  #   @counter = objects.count
  #   list_of_objects = ""
  #   objects.each do |object|
  #     list_of_objects += nav_show(object.name, object.class, object.id) + comma_separator(@counter-=1)
  #   end
  #   return list_of_objects
  # end
  # 
  # def list_objects_globalite(objects)
  #   @counter = count_objects(objects)
  #   list_of_objects = ""
  #   objects.each { |object|  list_of_objects += globalite_l(object.name) + comma_separator(@counter -= 1) }
  #   return list_of_objects
  # end
  # 
  # def list_objects_count(objects)
  #   @counter = 0
  #   objects.each { |object|  @counter += 1 }
  #   list_objects_count = ""
  #   objects.each do |object|
  #     list_objects_count += nav_show(object.name, object.class, object.id) + comma_separator(@counter-=1)
  #   end
  #   return list_objects_count
  # end
  # 
  # def list_objects_plain(objects)
  #   @counter = count_objects(objects)
  #   list_of_objects = ""
  #   objects.each { |object|  list_of_objects += object.name + comma_separator(@counter -= 1) }
  #   return list_of_objects
  # end
  # 
  # # returns a comma and space if counter > 0
  # def comma_counter(counter)
  #   return ", " if (@counter -= 1) > 0
  # end
  # 
  # def comma_separator(counter)
  #   return ",  " if counter > 0
  #   return ""
  # end
  
  def nice_time_at(time_at)
    return I18n.l(time_at, :format => :time_at) unless time_at.nil?
  end
  
  def nice_full_date(time_at)
    return I18n.l(time_at, :format => :full_date) unless time_at.nil?
  end
  
  def nice_day_of_week(time_at)
    return I18n.l(time_at, :format => :day_week) unless time_at.nil?
  end
  
  def nice_day_date(time_at)
    return I18n.l(time_at, :format => :day_date) unless time_at.nil?
  end
  
  def nice_day_weekday(time_at)
    return I18n.t(time_at, :format => :day_weekday) unless time_at.nil?
  end
  
  def nice_day_time(time_at)
    return I18n.l(time_at, :format => :day_time) unless time_at.nil?
  end
  
  def nice_day_date_wo_year(time_at)
    return I18n.l(time_at, :format => :day_date_wo_year) unless time_at.nil?
  end
  
  def nice_day_time_wo_year(time_at)
    return I18n.l(time_at, :format => :day_time_wo_year) unless time_at.nil?
  end

  def upcoming_schedules
    @upcoming_schedules ||= Schedule.upcoming_schedules(session[:schedule_hide_time])
  end
  
  def current_messages
    @current_messages ||= Message.current_messages(current_user)
  end
  
  def year_range( start_year = Time.now.year )
    [start_year, Time.now.year].sort.uniq.join('-')
  end  
end
