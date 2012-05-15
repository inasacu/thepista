require 'rest-client'
require 'json'

module AYAH
  
  # Are You a Human Publisher Integration Rubygem
  
  class Integration
    
    attr_accessor :publisher_key, :scoring_key, :ayah_server
    attr_reader :__score_result_status_code, :__last_error, :passed, :converted
    
    # @attr_accessor [String] publisher_key this key can be found in the AYAH portal
    # @attr_accessor [String] scoring_key this key can also be found in the AYAH portal
    # @attr_accessor [String] ayah_server you shouldn't have to modify this, `ws.areyouahuman.com`
    
    # @attr_reader [True,False,nil] passed this will be nil until a score request is made, then either true or false
    # @attr_reader [True,False,nil] converted this will be nil until convert html is called for, then true
    def initialize(publisher_key, scoring_key, ayah_server = 'ws.areyouahuman.com')
      @publisher_key = publisher_key
      @scoring_key = scoring_key
      @ayah_server = ayah_server
      @passed = nil
      @converted = nil
    end
    
    # returns the HTML string that should be embedded into the form page to be protected
    #
    # @return [String] the HTML string
    def get_publisher_html
      "<div id='AYAH'></div><script src='https://#{@ayah_server}/ws/script/#{@publisher_key}' type='text/javascript' language='JavaScript'></script>"
    end
    
    # returns the score of the current session
    #
    # @param [String] session_secret the session_secret for the session to be scored
    # @param [String] client_ip the ip address being used by the client
    # @return [True,False] whether the session passed
    def score_result(session_secret, client_ip='0.0.0.0')
      
      # set up the url and form vars for web service submission
      sr_url = "https://#{@ayah_server}/ayahwebservices/index.php/ayahwebservice/scoreGame"
      payload = {:session_secret => session_secret, :client_ip => client_ip}
      
      result = RestClient.post sr_url, payload, :content_type => 'application/x-www-form-urlencoded'
      
      # if there was an HTTP error, fail them automatically
      unless result.code == 200
        log_error("ERROR: HTTP Response code: #{result.code}")
        @passed = false
        return @passed
      end
      
      json = JSON.parse(result)
      
      # set the score result and see if they passed
      unless json['status_code'].nil?
        @__score_result_status_code = json['status_code'].to_i
        @passed = (json['status_code'].to_i ==  1)
        return @passed
      end
    end
    
    # returns the HTML to be embedded in the landing page of a completed and converted session
    #
    # @param [String] session_secret the session_secret for the session that converted
    # @return [String] the HTML string
    def record_conversion(session_secret)
      @converted = true
      "<iframe style='border: none;' height='0' width='0' src='https://#{@ayah_server}/ws/recordConversion/#{session_secret}\"></iframe>"
    end
    
    # returns the last error, if any, that occurred
    #
    # @return [String] the last error
    def last_error
      @__last_error
    end
    
    private
    def log_error(msg)
      @__last_error = msg
      puts msg
    end
    
  end
  
end