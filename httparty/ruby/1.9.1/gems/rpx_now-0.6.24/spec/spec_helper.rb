$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

# ---- setup environment/plugin
require File.expand_path("../init", File.dirname(__FILE__))
API_KEY = '4b339169026742245b754fa338b9b0aebbd0a733'
API_VERSION = RPXNow.api_version
DOMAIN = RPXNow.domain

# ---- rspec
RSpec.configure do |config|
  config.before do
    RPXNow.api_key = API_KEY
    RPXNow.api_version = API_VERSION
    RPXNow.domain = DOMAIN
  end
end
