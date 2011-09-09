class AuthController < ApplicationController
  before_filter :require_user

  def new
    # get your api keys at https://www.linkedin.com/secure/developer
    @client = LinkedIn::Client.new(APP_CONFIG['linkedin']['api_key'], APP_CONFIG['linkedin']['secret_key'])
    request_token = @client.request_token(:oauth_callback => "http://#{request.host_with_port}/auth/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to @client.request_token.authorize_url

  end

  def callback
    @client = LinkedIn::Client.new(APP_CONFIG['linkedin']['api_key'], APP_CONFIG['linkedin']['secret_key'])
    @user = User.find(current_user)

    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = @client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      @client.authorize_from_access(session[:atoken], session[:asecret])
    end

    @profile = @client.profile
    @connections = @client.connections

    unless @profile.site_standard_profile_request.nil?

      @user.linkedin_url = @profile.site_standard_profile_request
      @user.linkedin_token = session[:atoken]
      @user.linkedin_secret = session[:asecret]
      @user.save
    end

    redirect_to @user
    return
  end

end






