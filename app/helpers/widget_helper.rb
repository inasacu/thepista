module WidgetHelper
  
  def self.widget_is_origin(origin)
    return origin=="widget"
  end
  
  def self.is_widget_signup_form(name=nil)
    if !nil?
      return name=="widget_signup_form"
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
           userIsPartOfevent = false
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
           
           if userIsPartOfevent
              
              case matchRecord.type_id
                
              when 1 # convocado
      					currentState = the_font_green((matchRecord.type_name).downcase)
      					option1 = link_to "Pasar a ausente", widget_change_user_state_path(:userid => current_user.id, :newstate => 3)
      					option2 = link_to "Pasar a ultima hora", widget_change_user_state_path(:userid => current_user.id, :newstate => 2)
              when 2 # ultima hora
      					currentState = the_font_yellow((matchRecord.type_name).downcase)
      					option1 = link_to "Pasar a convocado", widget_change_user_state_path(:userid => current_user.id, :newstate => 1)
      					option2 = link_to "Pasar a ausente", widget_change_user_state_path(:userid => current_user.id, :newstate => 3)
              when 3 # ausente
      					currentState = the_font_red((matchRecord.type_name).downcase)
      					option1 = link_to "Pasar a convocado", widget_change_user_state_path(:userid => current_user.id, :newstate => 1)
      					option2 = link_to "Pasar a ultima hora", widget_change_user_state_path(:userid => current_user.id, :newstate => 2)
              end
              
              return "<STRONG>#{I18n.t(:your_roster_status)}</STRONG> #{currentState} <br> #{option1} <br> #{option2}".html_safe
              
           else
             link_to( "Apuntate", {:controller => "widget", :action => "do_apuntate"},
               :ismock => false, :event => schedule.id, :isevent => true )
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

