class WorkersController < ApplicationController
	
	
	def run
	  worker = FibonacciWorker.new
	  worker.max = 1000
	  resp = worker.queue
	  render :json => resp
	end
	
end
