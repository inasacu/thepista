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
  
  
  # instancia
  
  def get_event_options(schedule=nil)
     
     if !schedule.nil?
       if current_user
         
         # if is real event
         if !schedule.id.nil?
           
           # checks if user is already part of the event and the group
           userIsPartOfEvent = false
           matchRecord = nil
           
           if current_user.is_member_of?(schedule.group)
             schedule.matches.each do |match| 
                if is_current_same_as(match.user)
                  matchRecord = match
                  userIsPartOfevent = true
                  break
                end 
              end
           end
           
           if userIsPartOfEvent
              
              options = Hash.new
              options[:convocado] = {:desc => "Pasar a convocado", :status => 1} 
              options[:ultima] = {:desc => "Pasar a ultima hora", :status => 2} 
              options[:ausente] = {:desc => "Pasar a ausente", :status => 3} 
              
              case matchRecord.type_id
                
              when 1 # convocado
      					currentState = the_font_green((matchRecord.type_name).downcase)
      					option1 = options[:ultima]
      				  option2 = options[:ausente]
      				when 2 # ultima hora
      					currentState = the_font_yellow((matchRecord.type_name).downcase)
      					option1 = options[:convocado]
      				  option2 = options[:ausente]
              when 3 # ausente
      					currentState = the_font_red((matchRecord.type_name).downcase)
      				  option1 = options[:convocado]
      				  option2 = options[:ultima]
      				end
              
              option1Link = link_to option1[:desc], 
                            widget_change_user_state_path(:eventid => schedule.id, :userid => current_user.id, 
                            :newstate => option1[:status])
    					
    					option2Link = link_to option2[:desc], 
                            widget_change_user_state_path(:eventid => schedule.id, :userid => current_user.id, 
                            :newstate => option2[:status])
    					
              return "<STRONG>#{I18n.t(:your_roster_status)}</STRONG> 
              #{currentState} <br> #{option1Link} <br> #{option2Link}".html_safe
              
           else
             link_to( "Apuntate", {:controller => "widget", :action => "do_apuntate",
               :ismock => false, :event => schedule.id, :isevent => true} )
           end
           
         else
           link_to( "Apuntate", {:controller => "widget", :action => "do_apuntate", 
             :ismock => true, :event => schedule.id, :isevent => true} )
         end
         
   		 else

   			link_to( "Apuntate", "#", :class => "auth_popup",  
   			:data => { :ismock => schedule.id.nil?, :event => schedule.id, :isevent => true} )

   		 end
     end
     
  end
  
end

