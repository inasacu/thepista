module WidgetHelper
  
  def self.widget_is_origin(origin)
    return origin=="widget"
  end
  
  def self.is_widget_form(value=nil)
    if !nil?
      return value=="widget_form"
    else
      return false
    end
  end
  
  def self.clean_session(session)
    if !session.nil?
      session.delete("widgetpista.isevent")
      session.delete("widgetpista.ismock")
      session.delete("widgetpista.eventid")
      session.delete("widgetpista.source_timetable_id")
      session.delete("widgetpista.event_starts_at")
    end
  end
  
  def self.clean_branch_url(url)
    
    url.sub!("http://", "")
    url.sub!("HTTP://", "")
    url.sub!("www.", "")
    url.sub!("WWW.", "")
    url.chomp!("/")
     
    return url
    
  end
	
	# returns the date of the next week day
	def self.datetime_from_week_day(wday)
	  date_time = DateTime.parse(Time.zone.now.to_s)
	  offset = 0
	  
	  todayWday = (date_time.wday == 0) ? 7 : date_time.wday
	  
	  # if is this week or next week
	  if wday < date_time.wday
	    offset = 1
	  end
	  	  
	  return DateTime.commercial(date_time.year, offset + date_time.cweek, wday)
	end
	
	def self.week_day_from_description(wday_description)
	  week_days = Hash.new
	  week_days = {"monday" => 1, "lunes" => 1, "tuesday" => 2, "martes" => 2,
	            "wednesday" => 3, "miercoles" => 3, "thursday" => 4, "jueves" => 4,
	            "friday" => 5, "viernes" => 5, "saturday" => 6, "sabado" => 6,
	            "sunday" => 7, "domingo" => 7}
	  return week_days[wday_description.downcase]
	end
	
	def self.week_day_name_from_number(wday_number)
	  week_days = Hash.new
	  week_days = {1 => "Lunes", 2 => "Martes", 3 => "Miercoles",
	              4 => "Jueves", 5 => "Viernes", 6 => "Sabado", 7 => "Domingo", 0 => "Domingo"}
	  return week_days[wday_number]
	end
  
  # instancia
  
  def get_event_options(schedule=nil)
     
     if !schedule.nil?
       if current_user
         
         # if is real event
         if !schedule.id.nil?
           
           # checks if user is already part of the event and the group
           user_ispart_ofevent = false
           match_record = nil
           
           if current_user.is_member_of?(schedule.group)
             schedule.matches.each do |match| 
                if match.user.id == current_user.id
                  match_record = match
                  user_ispart_ofevent = true
                  break
                end 
              end
           end
           
           if user_ispart_ofevent
              
              options = Hash.new
              options[:convocado] = {:desc => "Pasar a convocado", :status => 1} 
              options[:ultima] = {:desc => "Pasar a ultima hora", :status => 2} 
              options[:ausente] = {:desc => "Pasar a ausente", :status => 3} 
              
              case match_record.type_id
                
              when 1 # convocado
      					current_state = the_font_green((match_record.type_name).downcase)
      					option1 = options[:ultima]
      				  option2 = options[:ausente]
      				when 2 # ultima hora
      					current_state = the_font_yellow((match_record.type_name).downcase)
      					option1 = options[:convocado]
      				  option2 = options[:ausente]
              when 3 # ausente
      					current_state = the_font_red((match_record.type_name).downcase)
      				  option1 = options[:convocado]
      				  option2 = options[:ultima]
      				end
              
              option1_link = link_to option1[:desc], 
                            widget_change_user_state_path(:matchid => match_record.id,
                            :newstate => option1[:status])
    					
    					option2_link = link_to option2[:desc], 
                            widget_change_user_state_path(:matchid => match_record.id, 
                            :newstate => option2[:status])
    					
    					# options for logged users inside of the group
              return "<STRONG>#{I18n.t(:your_roster_status)}</STRONG> 
              #{current_state} <br> #{option1_link} <br> #{option2_link}".html_safe
              
           else
             
             # link for real events
             link_to( "Apuntate", {:controller => "widget", :action => "do_apuntate",
               :ismock => false, :event => schedule.id, :isevent => true} )
               
           end
           
         else
           
           # link for mock events
           link_to( "Apuntate", {:controller => "widget", :action => "do_apuntate", 
             :ismock => true, :event => schedule.id, :isevent => true, 
             :source_timetable_id => schedule.source_timetable_id,
             :block_token => Base64::encode64(schedule.starts_at.to_i.to_s)} )
             
         end # end if real event
         
   		 else
   		   
         # link for not logged users
   			 link_to( "Apuntate", "#", :class => "auth_popup",  
   			 :data => { :ismock => schedule.id.nil?, :event => schedule.id, :isevent => true, 
   			   :source_timetable_id => schedule.source_timetable_id, 
   			   :block_token => Base64::encode64(schedule.starts_at.to_i.to_s)} )

   		 end # end if logged user
   		 
     end # end if valid event
     
  end
  
  def get_match_options(match)
    
    options = Hash.new
    options[:convocado] = {:desc => "Pasar a convocado", :status => 1} 
    options[:ultima] = {:desc => "Pasar a ultima hora", :status => 2} 
    options[:ausente] = {:desc => "Pasar a ausente", :status => 3}
    options[:nopresente] = {:desc => "Pasar a no presentado", :status => 4}
    
    the_options = ""
    
		if match.type_id != 1
			the_options = "#{the_options} #{link_to( 
			image_tag(IMAGE_CONVOCADO, :title => options[:convocado][:desc], :style => 'height: 16px; width: 16px;'), 
      widget_change_user_state_path( :matchid => match.id, :newstate => options[:convocado][:status] ) ) }".html_safe
    end
		if match.type_id != 2
			the_options = "#{the_options} #{link_to( 
			image_tag(IMAGE_ULTIMA_HORA, :title => options[:ultima][:desc], :style => 'height: 16px; width: 16px;'), 
      widget_change_user_state_path( :matchid => match.id, :newstate => options[:ultima][:status] ) ) }".html_safe
		end
		if match.type_id != 3
			the_options = "#{the_options} #{link_to( 
			image_tag(IMAGE_AUSENTE, :title => options[:ausente][:desc], :style => 'height: 16px; width: 16px;'), 
      widget_change_user_state_path( :matchid => match.id, :newstate => options[:ausente][:status] ) ) }".html_safe
		end
		if match.type_id != 4
			the_options = "#{the_options} #{link_to( 
			image_tag(IMAGE_NO_DISPONIBLE, :title => options[:nopresente][:desc], :style => 'height: 16px; width: 16px;'), 
      widget_change_user_state_path( :matchid => match.id, :newstate => options[:nopresente][:status] ) ) }".html_safe
		end
    
    return the_options
    
  end
  
  def get_header_menu_li(schedule=nil)
    home_li = ""
	  event_li = ""
	  invitation_li = ""
	  
    case self.controller.action_name
  	when 'event_invitation' # invitation
  	  
  	  home_li = "#{content_tag(:li, link_to('Inicio', widget_home_url))}"
  	  event_li = "#{content_tag(:li, link_to("Convocados", 
  	                widget_event_details_path(:event_id => schedule)))}"
  	  invitation_li = "#{content_tag(:li, link_to("Invita a tus amigos a este evento", 
  	                    widget_event_invitation_path(:event_id => schedule)), :class => 'active')}"
  	  
  	when 'home' # home
  	  
  	  home_li = "#{content_tag(:li, link_to('Inicio', widget_home_url), :class => 'active')}"
  	  
  	when 'event_details' # event details
  	  
  	  home_li = "#{content_tag(:li, link_to('Inicio', widget_home_url))}"
  	  event_li = "#{content_tag(:li, link_to("Convocados", 
  	                widget_event_details_path(:event_id => schedule)), :class => 'active')}"
  	  if current_user
  	    invitation_li = "#{content_tag(:li, link_to("Invita a tus amigos a este evento", 
    	                    widget_event_invitation_path(:event_id => schedule)))}"
  	  end
  	  
  	end
  	return "#{home_li} #{event_li} #{invitation_li}".html_safe
  end
  
end

