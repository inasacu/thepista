
# Notify Hoptoad if there’s an exception in Delayed::Job
# http://trevorturk.com/2011/01/25/notify-hoptoad-if-theres-an-exception-in-delayedjob/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed:+trevorturk+(Trevor+Turk)

Delayed::Worker.destroy_failed_jobs = false

class Delayed::Worker
  alias_method :original_handle_failed_job, :handle_failed_job

  def handle_failed_job(job, error)
    HoptoadNotifier.notify(error)
    original_handle_failed_job(job, error)
  end
end