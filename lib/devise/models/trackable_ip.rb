# lib/devise/models/trackable_ip.rb
module Devise
  module Models
    module TrackableIp
      extend ActiveSupport::Concern
      include DeviseTrackableIp::TrackableIp

      def update_tracked_fields(request)
        super
        update_tracked_ip(request)
      end
    end
  end
end