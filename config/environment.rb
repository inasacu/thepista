# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  
  config.gem "authlogic"
  config.gem "will_paginate"
  config.gem "authlogic-oid", :lib => "authlogic_openid"
  config.gem "ruby-openid", :lib => "openid"
  config.gem "be9-acl9", :source => "http://gems.github.com", :lib => "acl9"
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :es
end






# this code from 
# # http://gravityblast.com/
# # a trick to show form error messages inside the auto generated forms, you can add the following lines in your environment.rb:
# 
# ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
#   if html_tag =~ /<label/
#     %|<div class="fieldWithErrors">#{html_tag} <span class="error">#{[instance.error_message].join(', ')}</span></div>|
#   else
#     html_tag
#   end
# end


################### original source
# 
# require 'solr_pagination'
# 
# 
# # Can be 'object roles' or 'hardwired'
# AUTHORIZATION_MIXIN = "object roles"
# 
# # The method your auth scheme uses to store the location to redirect back to
# STORE_LOCATION_METHOD = :store_location
# 
# # global variables
# # url to get users to signup
# NEW_OPENID_URL = "https://www.myopenid.com/affiliate_signup?affiliate_id=1443"
# CONTACT_RECIPIENT = 'support@haypista.com'
# 
# # Load custom config file for current environment
# raw_config = File.read(RAILS_ROOT + "/config/config.yml")
# APP_CONFIG = YAML.load(raw_config)[RAILS_ENV]
# 
# BASE_URL = 'https://rpxnow.com'
# GRAVATAR_URL = 'http://en.gravatar.com/site/signup'
# 
# 
# # Workaround to make ruby-openid work with Passenger, because these two don't always cooperate.
# # http://groups.google.com/group/phusion-passenger/browse_thread/thread/30b8996f8a1b11f0/ba4cc76a5a08c37d? @@@ hl=en&lnk=gst&q=
# OpenID::Util.logger = RAILS_DEFAULT_LOGGER
# 
# ExceptionNotifier.exception_recipients = %w(support@haypista.com)
# 
# 
# config.action_mailer.delivery_method = :smtp
# ActionMailer::Base.smtp_settings = {
#   :address  => "smtp.someserver.net",
#   :port  => 25,
#   :user_name  => "someone@someserver.net",
#   :password  => "mypass",
#   :authentication  => :login
# }