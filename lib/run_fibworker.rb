require 'iron_worker'
require_relative 'fibonacci_worker'

IronWorker.configure do |config|
  config.token = 'YOUR TOKEN HERE'
  config.project_id = 'YOUR PROJECT ID HERE'
end

worker = FibonacciWorker.new
worker.max = 1000
worker.run_local