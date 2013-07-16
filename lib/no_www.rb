# http://trevorturk.com/2009/11/05/no-www-rack-middleware/
# lib/no_www.rb


# class NoWWW
#  
#   STARTS_WITH_WWW = /^www\./i
#   
#   def initialize(app)
#     @app = app
#   end
#   
#   def call(env)
#     if env['HTTP_HOST'] =~ STARTS_WITH_WWW
#       [301, { 'Location' => Rack::Request.new(env).url.sub(/www\./i, '') }, ['Redirecting...']]
#     else
#       @app.call(env)
#     end
#   end
#   
# end

class NoWww

  def initialize(app)
    @app = app
  end

  def call(env)

    request = Rack::Request.new(env)

    if request.host.start_with?("www.")
      [301, {"Location" => request.url.sub("//www.", "//")}, self]
    else
      @app.call(env)
    end
  end

  def each(&block)
  end

end


