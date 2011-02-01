# Module used to conform to Rails 3 plugin API
require File.expand_path( File.dirname(__FILE__) + '/../texticle')

module Texticle
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.dirname(__FILE__) + '/tasks.rb'
    end

    initializer "texticle.configure_rails_initialization" do
      ActiveRecord::Base.extend(Texticle)
    end
  end
end
