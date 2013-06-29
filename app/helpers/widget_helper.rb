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
      session["widgetpista.ismock"] = nil
      session["widgetpista.eventid"] =  nil
      session["widgetpista.source_timetable_id"] =  nil
      session["widgetpista.pos_in_timetable"] = nil
    end
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
                            widget_change_user_state_path(:eventid => schedule.id, :userid => current_user.id, 
                            :newstate => option1[:status])
    					
    					option2_link = link_to option2[:desc], 
                            widget_change_user_state_path(:eventid => schedule.id, :userid => current_user.id, 
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
             :source_timetable_id => schedule.source_timetable_id, :pos_in_timetable => schedule.pos_in_timetable} )
             
         end # end if real event
         
   		 else
   		   
         # link for not logged users
   			 link_to( "Apuntate", "#", :class => "auth_popup",  
   			 :data => { :ismock => schedule.id.nil?, :event => schedule.id, :isevent => true, 
   			   :source_timetable_id => schedule.source_timetable_id, :pos_in_timetable => schedule.pos_in_timetable} )

   		 end # end if logged user
   		 
     end # end if valid event
     
  end
  
end

