# lib/devise-trackable-ip/trackable_ip.rb
module DeviseTrackableIp
  module TrackableIp
    extend ActiveSupport::Concern

    included do
      has_many :user_ip_addresses, class_name: 'DeviseTrackableIp::Models::TrackableIp', as: :user, dependent: :delete_all
    end

    def update_tracked_ip(request)
      return unless request.remote_ip

      ip_address = request.remote_ip
      current_time = Time.current

      user_ip_addresses.create(ip_address: ip_address, visited_at: current_time)
    end
  end
end