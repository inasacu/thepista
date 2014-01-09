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
      security_error_response("Security error checking auth token")
    end
  end
  
  def mobile_response(response_code=nil, response_message=nil)
    response = Mobile::MobileResponse.new
    response.code = response_code
    response.message = response_message
    render json: response
    return
  end
  
  def success_response(response_message=nil)
    mobile_response("00", response_message)
  end
  
  def error_response(response_message=nil)
    if response_message.nil?
      response_message = "Error while handling operation"
    end
    mobile_response("88", response_message)
  end
  
  def security_error_response(response_message=nil)
    if response_message.nil?
      response_message = "Security error on mobile request"
    end
    mobile_response("99", response_message)
  end
  
end