require 'devise/hooks/trackable_ip'

module Devise
  module Models
    module TrackableIp
      extend ActiveSupport::Concern

      included do |container|
        puts ">>>> #{container}"
        ancestor = container.class.name.demodulize.underscore
        has_many :trackable_ips, class_name: 'DeviseTrackableIp::Models::TrackableIp', as: :trackable, dependent: :delete_all
      end

      def update_tracked_ip(request)
        return unless request.remote_ip

        ip_address = request.remote_ip
        current_time = Time.current.utc

        trackable_ips.new(visited_at: current_time).fields_from_string_ip(ip_address).save!
      end
    end
  end
end