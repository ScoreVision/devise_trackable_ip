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

        ip_address = IPAddr.new(request.remote_ip)
        current_time = Time.current.utc

        record = trackable_ips.find_or_create_by(ip_address: ip_address.to_i, ip_address_type: ip_address.family)
        record.add_visit(current_time)
        record.save
      end
    end
  end
end