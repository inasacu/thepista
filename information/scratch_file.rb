
def show_index
  # get your api keys at https://www.linkedin.com/secure/developer
  client = LinkedIn::Client.new(APP_CONFIG['linkedin']['api_key'], APP_CONFIG['linkedin']['secret_key'])
  request_token = client.request_token(:oauth_callback => "http://#{request.host_with_port}/auth/callback")
  session[:rtoken] = request_token.token
  session[:rsecret] = request_token.secret
  redirect_to client.request_token.authorize_url
end

def callback
  client = LinkedIn::Client.new("your_api_key", "your_secret")
  if session[:atoken].nil?
    pin = params[:oauth_verifier]
    atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
    session[:atoken] = atoken
    session[:asecret] = asecret
  else
    client.authorize_from_access(session[:atoken], session[:asecret])
  end
  @profile = client.profile
  @connections = client.connections
end
  
def show
  store_location
  # get your api keys at https://www.linkedin.com/secure/developer
  
  # client = LinkedIn::Client.new(APP_CONFIG['linkedin']['api_key'], APP_CONFIG['linkedin']['secret_key'])
  # rtoken = client.request_token.token
  # rsecret = client.request_token.secret
  # 
  # # to test from your desktop, open the following url in your browser
  # # and record the pin it gives you
  # client.request_token.authorize_url
  # => "https://api.linkedin.com/uas/oauth/authorize?oauth_token=<generated_token>"
  # 
  # # then fetch your access keys
  # client.authorize_from_request(rtoken, rsecret, pin)
  # => ["05984f88-e096-4fae-8f2d-13915bf87f4f", "8c4b59f5-6046-4155-8c4a-44a4d80e791a"] # <= save these for future requests
  # 
  # # or authorize from previously fetched access keys
  # client.authorize_from_access("05984f88-e096-4fae-8f2d-13915bf87f4f", "8c4b59f5-6046-4155-8c4a-44a4d80e791a")

  # you're now free to move about the cabin, call any API method
  
  # >> client = LinkedIn::Client.new(APP_CONFIG['linkedin']['api_key'], APP_CONFIG['linkedin']['secret_key'])
  # => #<LinkedIn::Client:0x5891610 @csecret="hWzelp5eIWkFX6wUTID6Dj3ljYnq6pTATQyYwtljCnH-azO4PJ1__N1nOThE-5fg", @ctoken="bMT6ozAQuigLB3B0rRvthjUdVucw9KaPmst3SI9-Ph6KPG9-T6Og5LGvcWF6hqS8", @consumer_options={:authorize_path=>"/uas/oauth/authorize", :access_token_path=>"/uas/oauth/accessToken", :request_token_path=>"/uas/oauth/requestToken"}>
  
  # >> rtoken = client.request_token.token
  # .=> "3cb25ceb-2030-4802-9e96-0454b81aa27a"
  
  # >> rsecret = client.request_token.secret
  # => "582a5f0c-5bc6-4e80-abd1-ecfa49c917b8"
  
  # >> client.request_token.authorize_url
  # => "https://api.linkedin.com/uas/oauth/authorize?oauth_token=3cb25ceb-2030-4802-9e96-0454b81aa27a"
  
  # >> pin=91443
  # => 91443
  
  # >> client.authorize_from_request(rtoken, rsecret, pin)
  # => ["05984f88-e096-4fae-8f2d-13915bf87f4f", "8c4b59f5-6046-4155-8c4a-44a4d80e791a"]
  
  # >> client.authorize_from_access("05984f88-e096-4fae-8f2d-13915bf87f4f", "8c4b59f5-6046-4155-8c4a-44a4d80e791a")
  # => ["05984f88-e096-4fae-8f2d-13915bf87f4f", "8c4b59f5-6046-4155-8c4a-44a4d80e791a"]
  
  
end




paypal sandbox accounts

raulmpadilla@gmail.com 19ti79q42e


test accounts 

raulmp_1308505502_per@gmail.com   308508306

raulmp_1308504683_biz@gmail.com   308504544


Test Account  Date Created
Test Account: raulmp_1308504683_biz@gmail.com Jun. 19, 2011 10:31:32 PDT
API Username: raulmp_1308504683_biz_api1.gmail.com
API Password: 1308504692
Signature:   AFcWxV21C7fd0v3bYYYRCpSSRl31AEhy4Ky1dOMe7W5n8hrUF5zlgF6b

thepista.local/jornadas/5949/cambio_convocatoria/2/dWIxYmt6Z2o1OTQ5eWpqaXY5cmw=%0A
thepista.local/jornadas/5949/cambio_convocatoria/3/dWIxYmt6Z2o1OTQ5eWpqaXY5cmw=%0A
thepista.local/jornadas/5949/cambio_convocatoria/1/dWIxYmt6Z2o1OTQ5eWpqaXY5cmw=%0A


Quieres que tus amigos se apunten a este partido?  Compartelo