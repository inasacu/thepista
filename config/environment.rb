# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Thepista::Application.initialize!

# rpx_now 
RPXNow.api_key = ENV['RPX_API_KEY']
RPX_APP_NAME = ENV['RPX_APP_NAME']

raise "RPX/Janrain Engage API key must be defined ENV['RPX_API_KEY']" unless RPXNow.api_key
raise "RPX/Janrain Engage Application Name must be defined ENV['RPX_APP_NAME']" unless RPX_APP_NAME


WillPaginate.per_page = 15	

ENV['IRON_WORKER_TOKEN'] = '12NrL0TfkunXS0L8BPYzM5JC7ss'
ENV['IRON_WORKER_PROJECT_ID'] = '5005be960008f24d9e0003c2'