# # Rails.root/config.ru
# require "config/environment"
# 
# use Rails::Rack::LogTailer
# use Rails::Rack::Static
# run ActionController::Dispatcher.new

# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Thepista::Application
