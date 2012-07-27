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
		return I18n.t(:"#{ value.to_s.humanize.downcase.gsub(' ','_') }#{ text }").html_safe
	end

	def label_name(value, text="")
		text.insert(0, '_') unless text.blank?
		return I18n.t(:"#{ value.to_s.downcase.gsub(' ','_') }#{ text }").html_safe
	end

	def label_with_name(value, name="", text="")
		return "#{label_name(value, text)}  #{name}"
	end

	def control_label(text="")
		text.insert(0, '_') unless text.blank?
		return I18n.t(:"#{ controller.controller_name.to_s.downcase.gsub(' ','_') }#{ text }").html_safe
	end

	def control_action_label(text="")
		text.insert(0, '_') unless text.blank?
		return I18n.t(:"#{ controller.controller_name.to_s.downcase.gsub(' ','_') }_#{ controller.action_name.to_s.downcase.gsub(' ','_') }#{ text }").html_safe
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

	def tr_td_action(label, value)
		if DISPLAY_HAYPISTA_TEMPLATE
			content_tag(:tr, content_tag(:td, label_name(label), :class => "label") + content_tag(:td, h(value), :class => get_the_action)) 
		else  
			content_tag(:tr, content_tag(:td, label_name(label)) + content_tag(:td, h(value)))
		end
	end

	# returns true / false if controller name passed is same is current
	def is_controller(aController)
		return (self.controller.controller_name.singularize.gsub("_", " ") == aController)
	end 

	# returns true / false if action within controller name passed is same is current
	def is_action(anAction)
		return (self.controller.action_name.singularize.gsub("_", " ") == anAction)
	end

	# returns true / false if action within controller action name passed is same is current
	def is_controller_action(aControllerAction)
		the_controller = self.controller.controller_name.singularize.gsub("_", " ")
		the_action = self.controller.action_name.singularize.gsub("_", " ")
		return ("#{the_controller}_#{the_action}" == aControllerAction)
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
		return I18n.t(:ago, :count => time_ago_in_words(time_at).capitalize).html_safe
	end

	def has_left(time_at)
		return I18n.t(:has_left, :count => time_ago_in_words(time_at).capitalize).html_safe
	end

	# Sábado, a las 20:30
	def nice_day_time(time_at)
		return I18n.l(time_at, :format => :day_time).html_safe unless time_at.nil?
	end

	# 20:30
	def nice_simple_time_at(time_at)
		return I18n.l(time_at, :format => :simple_time_at).html_safe unless time_at.nil?
	end

	# July 2012
	def nice_month_year(time_at)
		return I18n.l(time_at, :format => :month_year).html_safe unless time_at.nil?
	end

	# July 
	def nice_month_full(time_at)
		return I18n.l(time_at, :format => :month_full).html_safe unless time_at.nil?
	end


	# day: 18
	def nice_day_time_at(time_at)
		return I18n.l(time_at, :format => :day).html_safe unless time_at.nil?
	end

	# hour: 20
	def nice_hour_time_at(time_at)
		return I18n.l(time_at, :format => :hour).html_safe unless time_at.nil?
	end

	# minute: 30
	def nice_minute_time_at(time_at)
		return I18n.l(time_at, :format => :minute).html_safe unless time_at.nil?
	end

	# month: 9
	def nice_month_time_at(time_at)
		return I18n.l(time_at, :format => :month) unless time_at.nil?
	end

	# year: 11
	def nice_year_time_at(time_at)
		return I18n.l(time_at, :format => :year).html_safe unless time_at.nil?
	end

	# 20:30 +0200
	def nice_simple_time_zone_at(time_at)
		return I18n.l(time_at, :format => :simple_time_zone_at).html_safe unless time_at.nil?
	end

	# a las 20:30
	def nice_time_at(time_at)
		return I18n.l(time_at, :format => :time_at).html_safe unless time_at.nil?
	end

	# 12 de Junio de 2010
	def nice_full_date(time_at)
		return I18n.l(time_at, :format => :full_date).html_safe unless time_at.nil?
	end

	# Sábado, 12 de Junio de 2010 a las 20:30
	def nice_day_of_week(time_at)
		return I18n.l(time_at, :format => :day_week) unless time_at.nil?
	end

	# Sábado, 12 de Junio de 2010 a las 20:30
	def nice_weekday(time_at)
		return I18n.l(time_at, :format => :day_of_week).html_safe unless time_at.nil?
	end

	# 12 de Junio de 2010 a las 20:30
	def nice_date_hour(time_at)
		return I18n.l(time_at, :format => :date_hour).html_safe unless time_at.nil?
	end

	# translation missing: es, 2010-06-12 20:30:00 +0200
	def nice_day_date(time_at)
		return I18n.l(time_at, :format => :day_date).html_safe unless time_at.nil?
	end

	# translation missing: es, 2010-06-12 20:30:00 +0200
	def nice_day_weekday(time_at)
		return I18n.t(time_at, :format => :day_weekday).html_safe unless time_at.nil?
	end

	# 12 de Junio
	def nice_date_wo_year(time_at)
		return I18n.l(time_at, :format => :date_wo_year).html_safe unless time_at.nil?
	end

	# Sábado, 12 de Junio
	def nice_day_date_wo_year(time_at)
		return I18n.l(time_at, :format => :day_date_wo_year) unless time_at.nil?
	end

	# Sábado, 12 de Junio a las 20:30
	def nice_day_time_wo_year(time_at)
		return I18n.l(time_at, :format => :day_time_wo_year).html_safe unless time_at.nil?
	end

	# Sábado, 12 de Junio 20:30
	def nice_day_time_wo_year_exact(time_at)
		return I18n.l(time_at, :format => :day_time_wo_year_exact).html_safe unless time_at.nil?
	end

	# converts two dates and get date and time from first and second
	def convert_to_datetime_zone(the_date, the_time)
		the_datetime = "#{the_date.strftime('%Y%m%d')} #{nice_simple_time_zone_at(the_time)} "
		return DateTime.strptime(the_datetime, '%Y%m%d %H:%M %z')
	end

	def limit_url_length(text)
		text = h(text)
		text = "#{text.to_s.strip[0..12]}..." if text.to_s.length > 14
		text = text.gsub(" ", "<wbr> ".html_safe)
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
		if DISPLAY_HAYPISTA_TEMPLATE
			content_tag(:h2, h(text), :class => :title )
		else
			content_tag(:h4, h(text), :class => :title )
		end
	end

	def set_content_tag(text)
		if DISPLAY_HAYPISTA_TEMPLATE
			content_tag :h3, text
		else
			content_tag :h4, text
		end
	end

	def set_title_class(text, image_label=nil)
		if DISPLAY_HAYPISTA_TEMPLATE
			set_content_tag_safe(:h2, "#{image_label.nil? ? '' : option_image_link(image_label)}  #{text}", "title")
		else
			set_content_tag_safe(:h4, "#{image_label.nil? ? '' : option_image_small_link(image_label)}  #{text}", "title")
		end
	end

	def set_image_and_link(the_link, image_label=nil)
		if DISPLAY_HAYPISTA_TEMPLATE
			set_content_tag_safe(:p, "#{image_label.nil? ? '' : option_image_link(image_label)}  #{the_link}", "")
		else
			set_content_tag_safe(:p, "#{image_label.nil? ? '' : option_image_small_link(image_label)}  #{the_link}", "")
		end
	end

	def set_sidebar(the_render=nil)
		if DISPLAY_HAYPISTA_TEMPLATE
			if the_render.nil?
				content_for :sidebar, render("#{get_the_controller}/sidebar")
			else
				content_for :sidebar, the_render
			end
		end
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
		link_to(text.html_safe, item, html_options)
	end

	def limit_item_link_length(text, value)
		text = h(text)
		text = "#{text.to_s.strip[0..value]}..." if text.to_s.length > value
		text = text.split.collect {|i| i.capitalize}.join(' ')
		return text
	end

	def option_image_link(item, align='')
		the_image = "icons/#{item}.png"
		return image_tag(the_image, options={:style => 'height: 24px; width: 24px;', :align => align})
	end

	def option_image_small_link(item, align='')
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
		the_link = "#{items.first.class.to_s.downcase.chomp}_link".html_safe
		list_of_items = ""
		items.each do |item|
			list_of_items += send(:"#{the_link}", item)
			list_of_items += ", "      
		end
		return list_of_items.chop.chop.html_safe
	end

	def item_new(item)  
		if (is_action('new') or is_action('create'))
			the_controller = item.class.to_s.downcase.chomp
			the_url = "new_#{the_controller}_url"
			the_active = get_active("#{the_controller}_new")

			if DISPLAY_HAYPISTA_TEMPLATE
				content_tag(:li, link_to(control_action_label, send(:"#{the_url}")), :class => 'first active') if (is_action('new') or is_action('create'))
			else
				set_tab_navigation(link_to(control_action_label, send(:"#{the_url}"), :class => the_active)) 
			end
		end
	end

	def sort_link(title, column, options = {})
		condition = options[:unless] if options.has_key?(:unless)
		sort_dir = params[:d] == 'up' ? 'down' : 'up'
		link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
	end

	def get_secondary_navigation(item=nil, game=nil)
		return "" unless DISPLAY_HAYPISTA_TEMPLATE
		the_controller = is_controller('home') ? "#{get_the_controller}" : "#{get_the_controller}s"
		return render("#{the_controller}/secondary_navigation".html_safe) if item.nil? 
		return render("#{(item.class.to_s).downcase}s/secondary_navigation".html_safe, :item => item) if game.nil?
		return render("#{(item.class.to_s).downcase}s/secondary_navigation".html_safe, :item => item, :game => game) 
	end

	def get_class_table_id_controller
		the_controller = get_the_controller.gsub(' ','_')
		"<table class='table' id='#{the_controller}'>".html_safe
	end

	def get_class_table_id_action
		the_action = get_the_action.gsub(' ','_')
		"<table class='table' id='#{the_action}'>".html_safe
	end

	def get_cluetip(the_label, image_name, the_description, icon_only=false, align='')
		the_image = ''
		the_image = option_image_link(image_name, align) unless image_name.nil?
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

		return "#{the_image}&nbsp;&nbsp;#{the_content} #{the_content_div}".html_safe
	end

	def get_cluetip_show(the_label, align='right')	  
		the_description = I18n.t("#{the_label}_cluetip") 
		the_label = I18n.t(the_label)
		return "#{the_label}#{get_cluetip(the_label, 'info', the_description, true, align)}".html_safe
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
		return the_content.html_safe
	end

	def control_description(value, no_description=false)
		the_description = I18n.t(value)
		the_description = control_label("#{value}_description") unless no_description
		return "#{the_description}...".html_safe
	end

	def get_header_navigation
		has_group ||= false

		if current_user 
			has_group = current_user.has_group? 
		end

		the_cup = ""
		the_challenge = ""
		the_schedule = ""
		the_group = ""
		the_users = ""
		the_user = ""
		the_petition = ""
		the_home = ""
		the_login = ""
		the_signup = ""
		the_venue = ""
		the_message = ""
		the_controller_action = ['user_list', 'user_index']
		the_controller = get_the_controller

		case the_controller
		when 'home'
			the_home = "active"

		when 'cup', 'game', 'escuadra'
			the_cup = "active"

		when 'group'
			the_group = "active"

		when 'user'
			the_users = "active" if the_controller_action.include?(get_controller_action)
			the_user = "active" unless the_controller_action.include?(get_controller_action)
			if get_controller_action == 'user_petition'
				the_petition = "active" 
				the_user = ""
			end 

			the_signup = "active" if is_action('signup')

		when 'user session'
			the_login = "active" 

		when 'schedule', 'forum', 'match'
			the_schedule = (get_controller_action == "schedule_my_list")
			the_schedule = the_schedule ? is_current_same_as(@user) : true
			the_schedule = the_schedule ? "active" : " "
			the_user = "active" if the_controller_action.include?(get_controller_action)
			if get_controller_action == 'schedule_schedule_list'
				the_group = "active" 
				the_schedule = ""
			end

		when 'challenge', 'cast'
			the_cup = "active" if is_action('list gues')
			the_challenge = "active" unless is_action('list gues')

		when 'standing'
			the_cup = "active" unless is_action('show list')
			the_challenge = "active" if is_action('show list')

		when 'blog'
			if @user
				the_user = "active"
			elsif @group
				the_group = "active"
			else @challenge
				the_challenge = "active" 
			end

		when 'fee', 'payment'
			if @item and @item.class.to_s == 'Challenge' 
				the_challenge = "active" 
			elsif @user
				the_user = "active"
			elsif @group
				the_group = "active"
			end

		when 'message', 'invitation'
			the_message = "active"

		when 'venue', "installation", "reservation"
			the_venue = "active"	
		end

		return has_group, the_cup, the_challenge, the_schedule, the_group, the_users, the_user, the_petition, the_home, the_login, the_signup, the_venue, the_message, the_controller_action , the_controller

	end


	def set_form_button_submit(item)
		return "#{set_form_button(item)} #{label_name(:or)} #{set_form_cancel(item)}".html_safe
	end

	def set_form_button(item, the_label='', the_button='')
		the_button_class = "button"
		the_button_class = "small white nice button radius"
		the_button_class = the_button unless the_button.blank?
		return submit_tag(item.new_record? ? control_label('create') : control_label('edit'), :class => the_button_class) #unless the_label.blank?
		return submit_tag(label_name(the_label), :class => the_button_class)
	end 

	def set_form_cancel(item)
		the_path = "#{item.class.to_s.downcase.chomp}s_path"
		link_to(I18n.t(:cancel), send(:"#{the_path}"))    
	end

	def set_form_label(form, field, the_label='')
		form_label = (the_label.blank? ? field : the_label)
		return form.label :"#{field}", label_name(form_label)
	end

	def set_form_text_field(form, field, the_class, placeholder=false)
		if placeholder
			return form.text_field :"#{field}", :class => the_class, :placeholder => label_name(:"#{field}") 
		else  
			return form.text_field :"#{field}", :class => the_class
		end
	end

	def set_form_password(form, field, the_class, placeholder=false)
		if placeholder
			return form.password_field :"#{field}", :class => the_class, :placeholder => label_name(:"#{field}") 
		else  
			return form.password_field :"#{field}", :class => the_class
		end
	end

	def set_form_select(form, field_id, field_name, selection, include_blank=true)
		form.select(:"#{field_id}", field_name, {:selected => selection, :include_blank => include_blank})
	end 

	def set_form_text_area(form, field, placeholder=false, cols="40px%", rows="5px")
		if placeholder
			return form.text_area :"#{field}", :placeholder => label_name(:"#{field}"), :cols => cols, :rows => rows
		else
			return form.text_area :"#{field}", :cols => cols, :rows => rows
		end
	end

	def set_form_checkbox(form, field)
		return form.check_box :"#{field}", :class => 'check_box'
	end

	def set_form_time_select(form, field)
		return form.time_select :"#{field}", :class => 'datetime_select'
	end

	def set_form_datetime_select(form, field)
		return form.datetime_select :"#{field}", :class => 'datetime_select'
	end

	def set_form_date_select(form, field)
		return form.date_select :"#{field}", :class => 'datetime_select'
	end

	def set_timezone_select(form)
		return form.time_zone_select :time_zone, ActiveSupport::TimeZone.us_zones
	end

	def set_form_file_field(form, field)
		return form.file_field :"#{field}", :class => 'textphoto'
	end

	def render_show_detail_zurb(item_label, item_link, unique_label=false)
		the_item_label = ""
		if unique_label
			the_item_label = "#{item_label}".html_safe
		else
			the_item_label = label_name( :"#{item_label}").html_safe
		end
			
		return render('shared/show_detail_zurb'.html_safe, :item_label => the_item_label, :item_link => item_link)
	end

	def set_tab_navigation(the_label)
		return content_tag(:dd, the_label) 
	end

	def set_tab_navigation_active(controller_action)
		return :class => get_active(controller_action)
	end

	def set_form_create(item)
		the_item = item.class.to_s.downcase.chomp
		the_path = "new_#{the_item}_url"
		the_label = "#{the_item}s_create"
		# link_to(I18n.t(:"#{the_label}"), send(:"#{the_path}", item))
		link_to(I18n.t(:"#{the_label}"), send(:"#{the_path}"))
	end

	def set_form_create_image_link(item)
		the_item = item.class.to_s.downcase.chomp
		set_image_and_link(set_form_create(item), the_item)
	end

	def set_form_edit(item, label='')
		the_path = "edit_#{item.class.to_s.downcase.chomp}_path"
		the_label = label.blank? ? I18n.t(:edit) : I18n.t(label)
		link_to(the_label.html_safe, send(:"#{the_path}", item))
	end

	def set_form_edit_image_link(item, label='')
		set_image_and_link(set_form_edit(item, label), item.class.to_s.downcase.chomp)
	end

	def set_form_create_id(item, id, item_id, label='')
		the_item = item.class.to_s.downcase.chomp
		the_path = "new_#{the_item}_url"
		the_label = label.blank? ? I18n.t(:create) : I18n.t(label)
		link_to(the_label.html_safe, send(:"#{the_path}", :"#{id}" => item_id))
	end

	def set_form_create_id_image_link(item, id, item_id, label='',image='')
		set_image_and_link(set_form_create_id(item, id, item_id, label),( image.blank? ? item.class.to_s.downcase.chomp : image))
	end  

	def set_class_name_and_date(first_item, second_item)
		the_span = content_tag('span', second_item.html_safe, :class => 'date')
		# return content_tag('td', "#{first_item}<br />#{the_span}".html_safe, :class => 'name_and_date')
		return set_content_tag_safe(:td, "#{first_item}<br />#{the_span}", 'name_and_date')
	end

	def set_content_tag_safe(html_value, display_value, class_value='')
		content_tag(:"#{html_value}", display_value.html_safe, :class => class_value)
	end

	def content_tag_safe(html_value, display_value, title_value='', align='', class_value='')
		content_tag(:"#{html_value}", "#{display_value}".html_safe, :title => title_value, :align => align, :class => class_value)
	end

	def flash_messages(options={})
		if !flash.empty?
			s = "<div class=\"flash_messages_container\">"
			s2 = ""
			flash.each do |type, msg|
				clazz = "flash #{type}"
				if msg.is_a?(Array)
					msg.each do |m|
						s2 << content_tag(:div, m, :class =>clazz)
					end
				else
					s2 << content_tag(:div, msg, :class =>clazz)
				end
			end
			s << s2
			s << "</div>"
			s.html_safe
		end
	end

	def the_maximo
		current_user.is_maximo?
	end

	def is_group_manager_of
		current_user.is_group_manager_of?
	end

	def is_current_manager_of(item)
		current_user.is_manager_of?(item) or current_user.is_creator_of?(item)
	end

	def is_user_manager_of(item)
		current_user.is_user_manager_of?(item)
	end

	def is_current_same_as(item)
		current_user == item
	end

	def the_label_options
		label_name(:options)
	end

	def is_current_member_of(item)
		current_user.is_member_of?(item)
	end

	def has_current_item_petition(item)
		current_user.has_item_petition?(current_user, item)
	end

	def days_in_month(month, year = Time.now.year)
		return 29 if month == 2 && Date.gregorian_leap?(year)
		COMMON_YEAR_DAYS_IN_MONTH[month]
	end

	def is_mobile_browser
		@browser_type == "mobile"
	end	

	def eight_twelve_columns
		eight_or_twelve_columns = is_mobile_browser ? "twelve columns" : "eight columns"
	end
	
	def phone_number_link(text)
	    sets_of_numbers = text.scan(/[0-9]+/)
	    # number = "+1-#{sets_of_numbers.join('-')}"
	    number = "#{sets_of_numbers.join('-')}"
	    link_to text, "tel:#{number}"
	end
	
end
