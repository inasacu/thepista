# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
# RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION    # requires bamboo upgrade

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  config.action_controller.resources_path_names = { :new => 'nuevo', :edit => 'modificar', :show => 'mostrar' }
  
  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem "authlogic"
  config.gem "will_paginate"
  config.gem "authlogic-oid",                     :lib => "authlogic_openid"
  config.gem "ruby-openid",                       :lib => "openid"
  config.gem "acl9",                              :lib => "acl9",                         :source => "http://gemcutter.org"
  config.gem "contacts"  
  config.gem 'sitemap_generator',                 :lib => false,                          :source => 'http://gemcutter.org'
  config.gem "edgarjs-ajaxful_rating",            :lib => "ajaxful_rating",               :source => "http://gems.github.com"
  config.gem 'jackdempsey-acts_as_commentable',   :lib => 'acts_as_commentable',          :source => "http://gems.github.com"
  config.gem "acts-as-taggable-on",                                                       :source => "http://gemcutter.org"
  config.gem 'hoptoad_notifier'
  config.gem 'rpx_now'
  config.gem "url_shortener"
  config.gem "i18n",                              :version => "~> 0.3.5"
  config.gem "ambethia-recaptcha",                :lib => "recaptcha/rails",              :source => "http://gems.github.com"
  config.gem "friendly_id",                       :version => "~> 3.1"
  config.gem "geokit"
  # config.gem "rails_best_practices"
  
  # config.gem "aws-s3"
  # config.gem "paperclip"
  # config.gem "nokogiri"
  # config.gem "subexec"
  # config.gem "mini_magick"
    
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
  # config.time_zone = 'UTC'
  config.time_zone = 'Madrid'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :es
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  
  config.action_view.sanitized_allowed_tags = 'br' 
  
end

ActionMailer::Base.default_content_type = "text/html"
ActionMailer::Base.smtp_settings = {
   :tls => true,
   :enable_starttls_auto => true,
   :address => "smtp.gmail.com",
   :port => "587",
   :domain => "haypista.com",
   :authentication => :plain,
   :user_name => "haypista@gmail.com",
   :password => "72dae4bc40" 
 }

# this code from http://gravityblast.com/
# shows form error messages inside the auto generated forms 
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
  if html_tag =~ /<label/
    %|<div class="fieldWithErrors">#{html_tag} <span class="error">#{[instance.error_message].join(', ')}</span></div>|
  else
    html_tag
  end
end

# google analytics
# Rubaidh::GoogleAnalytics.tracker_id = 'UA-3271268-1'

# Load custom config file for current environment
raw_config = File.read(RAILS_ROOT + "/config/config.yml")
APP_CONFIG = YAML.load(raw_config)[RAILS_ENV]

# # global variables
# # url to get users to signup
NEW_OPENID_URL = "https://www.myopenid.com/affiliate_signup?affiliate_id=1443"
CONTACT_RECIPIENT = 'support@haypista.com'

# # Workaround to make ruby-openid work with Passenger, because these two don't always cooperate.
# # http://groups.google.com/group/phusion-passenger/browse_thread/thread/30b8996f8a1b11f0/ba4cc76a5a08c37d? @@@ hl=en&lnk=gst&q=
# OpenID::Util.logger = RAILS_DEFAULT_LOGGER

require 'composite_primary_keys'

LANGUAGES = ['es', 'en']

# http://dirk.net/2009/02/11/rails-i18n-translation-missing-errors-in-production/
I18n.load_path = Dir.glob("#{RAILS_ROOT}/locales/**/*.{rb,yml}")
I18n.default_locale = 'es'
I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
# I18n.fallbacks.map('en' => 'es')
I18n.reload!
