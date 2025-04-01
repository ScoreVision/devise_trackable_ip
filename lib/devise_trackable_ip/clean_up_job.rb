#lib/devise-trackable-ip/clean_up_job.rb
module DeviseTrackableIp
  class CleanUpJob < ActiveJob::Base
    queue_as :default

    def perform
      DeviseTrackableIp.cleanup_now
      DeviseTrackableIp.schedule_cleanup
    end

    def self.job_exists?
      queue_name = queue_name_from_part(queue_name: queue_name)
      ActiveJob::Base.queue_adapter.enqueued_jobs.any? do |job|
        job[:job] == self && job[:queue_name] == queue_name
      end
    end
  end
end