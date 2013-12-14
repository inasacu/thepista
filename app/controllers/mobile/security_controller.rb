class Mobile::SecurityController < ActionController::Base
  
  def index
    # Render oauth page from the provider selected in the mobile app
    selected_oauth_provider = params[:oauth_provider]
        
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
  
  def check_active_token
    #token = params[:token]
    token = request.headers['HayPistaMobile-API-Key']
    response = Mobile::MobileResponse.new
    
    if Mobile::MobileToken.check_token(token)
    else
      security_error_response
    end
  end
  
  def success_response(response_message=nil)
    response = Mobile::MobileResponse.new
    response.code = "00"
    response.message = response_message
    render json: response
    return
  end
  
  def security_error_response(response_message=nil)
    response = Mobile::MobileResponse.new
    response.code = "99"
    response.message = response_message
    render json: response
    return
  end
  
end