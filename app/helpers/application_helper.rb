# Methods added to this helper will be available to all templates in the application.
require 'digest/md5'

module ApplicationHelper
  
  # site name
  def app_name
    "HayPista" if production?
    "ThePista" unless production?  
  end
  
  
  # easy and clean link_to w/ <li>
  def list_link_with_active(name, options = {}, html_options = {}, &block)
    opts = {}
    opts.merge!(:class => 'active') if current_page?(options)
    content_tag(:li, link_to(name, options, html_options, &block), opts)
  end
  
  def get_first_class
    return "first active" if is_action('index')
    return "first"    
  end
  
  def get_active
    return "active" unless is_action('index')
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


  def control_action_label(text="")
	  text.insert(0, '_') unless text.blank?
    return I18n.t(:"#{ controller.controller_name.to_s.downcase.gsub(' ','_') }_#{ controller.action_name.to_s.downcase.gsub(' ','_') }#{ text }")
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
  #   will_paginate collection, {:previous_label => t('will_paginate_previous'), :next_label => t('will_paginate_next')}.merge(options)
  # end
  # 
  # # options user for setting up the menu links
  # def link_to_controller(name, theClass='')
  #   link_to name, controller_url, :class => theClass
  # end
  # 
  # def link_to_controller_list(name, theClass='')
  #   link_to name, controller_list, :class => theClass
  # end
  # 
  # def link_to_controller_action(name, id='#', theClass='')
  #   link_to name, controller_action(id), :class => theClass
  # end
  # 
  # def link_to_new(name, theClass='')
  #   link_to name, :controller => get_the_controller, :action => :new
  # end
  # 
  # def link_to_show(name, id='#', theClass='')
  #   link_to name, :controller => get_the_controller, :action => :show, :id => id
  # end
  # 
  # def link_to_edit(name, id='#', theClass='')
  #   link_to name, :controller => get_the_controller, :action => :edit, :id => id
  # end
  # 
  # def controller_url
  #   url_for :controller => get_the_controller
  # end
  # 
  # def controller_list
  #   url_for :controller => get_the_controller, :action => :list
  # end
  # 
  # def controller_action(id)
  #   url_for :controller => get_the_controller, :action => get_the_action, :id => id
  # end
  #   
  
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
  # 
  # # returns a hiperlink to specific action
  # # params: text, controller, id
  # def nav_action(text, controller, action=nil, id=nil, title='')
  #   return link_to(text, {:controller => controller}, {:title => title}) if action.nil? and id.nil?
  #   return link_to(text, {:controller => controller, :action => action}, {:title => title}) if id.nil?
  #   return link_to(text, {:controller => controller, :action => action, :id => id}, {:title => title})  
  # end
  # 
  # # returns a hiperlink to show action
  # # params: text, controller, id
  # def nav_show(text, controller, id, div_class='')
  #   return "<a href=\"../../#{controller}/show/#{id}\">#{text}</a>" if div_class.nil?
  #   return "<a href=\"../../#{controller}/show/#{id}\" class=\"#{div_class}\">#{text}</a>"
  # end
  # 
  # # returns a hiperlink to show edit
  # # params: text, controller, id
  # def nav_edit(text, controller, id)    
  #   return link_to(text, {:controller => controller, :action => 'edit', :id => id}) 
  # end
  # 
  # def nav_cancel(text, controller, id, message='')    
  #   message = globalite_l("destroy_#{get_the_controller}")
  # 
  #   if current_user.is_maximo? or current_user.is_manager? or current_user.is_creator? or is_controller('message')
  #     return link_to(text, {:controller => controller, :action => 'destroy', :id => id}, :confirm => message + "?") 
  #   end
  #   return ""
  # end
  # 
  # # used to translate combo fields and dbase default values
  # def globalite_l(value)
  #   return t(:"#{(value).to_sym}")
  # end
  # 
  # # used to translate true and false values
  # def globalite_b(value)
  #   return value.to_s == "true" ? t(:true_value) : t(:false_value)    
  # end
  # 
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
  
  def nice_day_of_week(time_at)
    return I18n.l(time_at, :format => :day_week) unless time_at.nil?
  end
  
  def nice_weekday_name(time_at)
    return I18n.l(time_at, :format => :day_weekday)
  end
  
  # def gravatar_url_for(email, options = {})    
  #   url_for({ :gravatar_id => Digest::MD5.hexdigest(email), :host => 'www.gravatar.com',      
  #     :protocol => 'http://', :only_path => false, :controller => 'avatar.php'    
  #     }.merge(options))  
  #   end
  # 
  #   def gravatar(email, user='')
  #     "<img alt=\"#{user}'s image\" src=\"/gravatars/#{MD5.new(email)}.gif\" height=\"80\" width=\"80\"/>"
  #   end
  # 
  #   def current_announcements
  #     @current_announcements ||= Announcement.current_announcements(session[:announcement_hide_time])
  #   end
  # 
  #   def current_classifieds
  #     @current_classifieds ||= Classified.current_classifieds(session[:classified_hide_time])
  #   end
  # 
  #   def current_schedules
  #     @current_schedules ||= Schedule.current_schedules(session[:schedule_hide_time])
  #   end
  # 
  #   def current_festivals
  #     @current_festivals ||= Festival.current_festivals(session[:festival_hide_time])
  #   end
  #   
  #   def current_messages
  #     @current_messages ||= Message.current_messages(current_user)
  #   end
  # 
  #   # Renders the current year.
  #   #  Example: 2008
  #   def current_year
  #     Time.now.year
  #   end
  # 
  #   def year_range( start_year = current_year )
  #     [start_year, current_year].sort.uniq.join('-')
  #   end  
  # 
  # 
  #   # Find all rows created on a certain day; Rails apparently has a built-in :db string format
  #   # self.find(:all, :conditions => ["created_at >= ? AND created_at <= ?", day.beginning_of_day.to_s(:db), day.end_of_day.to_s(:db)])
  #   # Find number of days between two dates
  #   def days_between_dates(first, last)
  #     (last.to_date.to_s.gsub("-", "").to_i) - (first.to_date.to_s.gsub("-", "").to_i)
  #   end
  # 
  #   def time_types 
  #     return [["00:00", "00:00"],["00:15", "00:15"],["00:30", "00:30"],["00:45", "00:45"],
  #     ["01:00", "01:00"],["01:15", "01:15"],["01:30", "01:30"],["01:45", "01:45"],
  #     ["02:00", "02:00"],["02:15", "02:15"],["02:30", "02:30"],["02:45", "02:45"],
  #     ["03:00", "03:00"],["03:15", "03:15"],["03:30", "03:30"],["03:45", "03:45"],
  #     ["04:00", "04:00"],["04:15", "04:15"],["04:30", "04:30"],["04:45", "04:45"],
  #     ["05:00", "05:00"],["05:15", "05:15"],["05:30", "05:30"],["05:45", "05:45"],
  #     ["06:00", "06:00"],["06:15", "06:15"],["06:30", "06:30"],["06:45", "06:45"],
  #     ["07:00", "07:00"],["07:15", "07:15"],["07:30", "07:30"],["07:45", "07:45"],
  #     ["08:00", "08:00"],["08:15", "08:15"],["08:30", "08:30"],["08:45", "08:45"],
  #     ["09:00", "09:00"],["09:15", "09:15"],["09:30", "09:30"],["09:45", "09:45"],
  #     ["10:00", "10:00"],["10:15", "10:15"],["10:30", "10:30"],["10:45", "10:45"],
  #     ["11:00", "11:00"],["11:15", "11:15"],["11:30", "11:30"],["11:45", "11:45"],
  #     ["12:00", "12:00"],["12:15", "12:15"],["12:30", "12:30"],["12:45", "12:45"],
  #     ["13:00", "13:00"],["13:15", "13:15"],["13:30", "13:30"],["13:45", "13:45"],
  #     ["14:00", "14:00"],["14:15", "14:15"],["14:30", "13:30"],["14:45", "14:45"],
  #     ["15:00", "15:00"],["15:15", "15:15"],["15:30", "15:30"],["15:45", "15:45"],
  #     ["16:00", "16:00"],["16:15", "16:15"],["16:30", "16:30"],["16:45", "16:45"],
  #     ["17:00", "17:00"],["17:15", "17:15"],["17:30", "17:30"],["17:45", "17:45"],
  #     ["18:00", "18:00"],["18:15", "18:15"],["18:30", "18:30"],["18:45", "18:45"],
  #     ["19:00", "19:00"],["19:15", "19:15"],["19:30", "19:30"],["19:45", "19:45"],
  #     ["20:00", "20:00"],["20:15", "20:15"],["20:30", "20:30"],["20:45", "20:45"],
  #     ["21:00", "21:00"],["21:15", "21:15"],["21:30", "21:30"],["21:45", "21:45"],
  #     ["22:00", "22:00"],["22:15", "22:15"],["22:30", "22:30"],["22:45", "22:45"],
  #     ["23:00", "23:00"],["23:15", "23:15"],["23:30", "23:30"],["23:45", "23:45"]].freeze 
  #   end
end
