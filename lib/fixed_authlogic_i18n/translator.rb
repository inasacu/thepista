# http://github.com/binarylogic/authlogic/issuesearch?state=open&q=I18n#issue/29
# http://logan.dk/post/398406302/fixing-authlogic-i18n

# temporary solution to following error
# moved from rails 2.3.2 to 2.3.5
# this breaks authlogic, error below:

# http://logan.dk/post/398406302/fixing-authlogic-i18n

# config/initializers/authlogic.rb

# lib/fixed_authlogic_i18n/translator.rb

module FixedAuthlogicI18n
  class Translator
    def translate(key, options = {})
      return Message.new(key, options)
    end
  end
  
  class Message
    def initialize(key, options)
      @key = key
      @options = options
    end
    
    def to_s
      I18n.t(@key, @options)
    end
    
    def +(other)
      self.to_s + other
    end
  end
end