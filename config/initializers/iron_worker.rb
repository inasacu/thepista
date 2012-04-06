IronWorker.configure do |config|
  config.token = ENV['IRON_WORKER_TOKEN']
  config.project_id = ENV['IRON_WORKER_PROJECT_ID']
  # Use the line below if you're using an ActiveRecord database
  config.database = Rails.configuration.database_configuration[Rails.env]
end



# IronWorker.configure do |config|
#   config.token = ENV['IRON_WORKER_TOKEN']
#   config.project_id = ENV['IRON_WORKER_PROJECT_ID']
#   config.auto_merge = true
#   config.database = Rails.configuration.database_configuration[Rails.env]
#   config.unmerge_gem('client_side_validations')
#   config.unmerge_gem('delayed_job')
#   config.unmerge_gem('devise')
# end