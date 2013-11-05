class Mobile::SecurityController < ActionController::Base

  def index
    # Render oauth page from the provider selected in the mobile app
    selected_oauth_provider = params[:oauth_provider]
    user = Mobile::UserMobile.new
    
    case selected_oauth_provider
      when "1"
        provider_url = "auth/facebook"
      when "2"
        provider_url = "auth/google"
      when "3"
        provider_url = "auth/windowslive"
    end
    
    provider_url = "#{provider_url}?origin=mobile" 
    redirect_to "#{root_url}#{provider_url}"
    
    return
  end
  
  def other_action
    #redirect_to root_url
    return
  end

end