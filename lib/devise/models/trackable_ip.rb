require 'devise/hooks/trackable_ip'

module Devise
  module Models
    module TrackableIp
      extend ActiveSupport::Concern

      included do |container|
        ancestor = container.class.name.demodulize.underscore
        has_many :trackable_ips, class_name: 'DeviseTrackableIp::Models::TrackableIp', as: :trackable, dependent: :delete_all
      end

      def update_tracked_ip(request, success = DeviseTrackableIp::Models::TrackableIp::FAILURE)
        # request could be a warden object or a rack env hash
        remote_ip = request.remote_ip if request.respond_to?(:remote_ip)
        remote_ip ||= request['REMOTE_ADDR'] if request.respond_to?(:dig)
        return unless remote_ip

        ip_address = IPAddr.new(remote_ip)
        current_time = Time.current.utc

        record = trackable_ips.find_or_create_by(ip_address: ip_address.to_i, ip_address_type: ip_address.family)
        record.add_visit(current_time, success)
        record.save
      end

      def login_history
        trackable_ips.map {|x| x.visited_at.map {|y| [Time.at(y[0]).to_datetime, x.ip_address.to_s, DeviseTrackableIp::Models::TrackableIp::STATUS_LOOKUP[y[1]]]}}
         .reduce(:concat)
         .sort {|x,y| x[0] <=> y[0]}
      end
    end
  end
end