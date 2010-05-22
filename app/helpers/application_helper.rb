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

  def ago(time_at)
    I18n.t(:ago, :count => time_ago_in_words(time_at).capitalize) 
  end
  
  def has_left(time_at)
    I18n.t(:has_left, :count => time_ago_in_words(time_at).capitalize) 
  end

  def nice_day_time(time_at)
    return I18n.l(time_at, :format => :day_time) unless time_at.nil?
  end

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

  def nice_day_date_wo_year(time_at)
    return I18n.l(time_at, :format => :day_date_wo_year) unless time_at.nil?
  end

  def nice_day_time_wo_year(time_at)
    return I18n.l(time_at, :format => :day_time_wo_year) unless time_at.nil?
  end

  def limit_url_length(text)
    text = h(text)
    text = "#{text.to_s.strip[0..12]}..." if text.to_s.length > 14
    text = text.gsub(" ", "<wbr> ")
    text = text.split.collect {|i| i.capitalize}.join(' ')
    return text
  end
  
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

  def page_title
    "HayPista" + ( " | " + @content_for_title if @content_for_title).to_s
  end

  def page_heading(text)
    content_tag(:h1, content_for(:title){ h(text) })
  end

  def page_description
    @content_for_description.to_s
  end

  def show_heading(text)
    content_tag(:h2, h(text), :class => :title )
  end

end
