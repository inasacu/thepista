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
  
end

