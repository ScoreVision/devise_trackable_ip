# lib/devise-trackable-ip/models/trackable_ip.rb
module DeviseTrackableIp
  module Models
    class TrackableIp < ActiveRecord::Base
      self.table_name = DeviseTrackableIp.table_name

      # Todo: This needs to be dynamic based on the class that devise_for is applied to
      belongs_to :trackable, polymorphic: true

      validates :ip_address, presence: true
      validates :visited_at, presence: true
      validates :trackable_id, presence: true
      validates :trackable_type, presence: true

      def self.clean_up(older_than)
        where('visited_at < ?', older_than).delete_all
      end

      def fields_from_string_ip(ip_str)
        input = IPAddr.new(ip_str)
        assign_attributes(ip_address: input.to_i, ip_address_type: input.family)
        self
      end

      def ip_address
        IPAddr.new(read_attribute(:ip_address), read_attribute(:ip_address_type))
      end
    end
  end
end