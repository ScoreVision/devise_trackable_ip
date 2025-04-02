#lib/devise-trackable-ip/clean_up_job.rb
module DeviseTrackableIp
  class CleanUpJob < ActiveJob::Base
    queue_as :default

    def perform
      DeviseTrackableIp.cleanup_now
      DeviseTrackableIp.schedule_cleanup
    end
  end
end