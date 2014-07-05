

ENV['THE_HOST'] = ENV["DEV_DISQUS_THE_HOST"] if Rails.env.development?
ENV['THE_HOST'] = ENV["STAGE_DISQUS_THE_HOST"] if Rails.env.staging?
ENV['THE_HOST'] = ENV["DISQUS_THE_HOST"] if Rails.env.production?
