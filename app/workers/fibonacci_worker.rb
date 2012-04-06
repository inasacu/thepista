require 'iron_worker'

class FibonacciWorker < IronWorker::Base

  attr_accessor :max

  def run
    values = Array.new
    num1 = 0
    num2 = 0
    nextNum = 1
    while nextNum < max
      num1 = num2
      num2 = nextNum
      nextNum = num1 + num2
      values << num2
    end
    log "#{values}"
  end

end