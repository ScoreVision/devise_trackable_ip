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

      def add_visit(timestamp)
        jsob = self.visited_at
        jsob << timestamp.to_i
        new_sort = jsob.reject {|t| t < DeviseTrackableIp.retention_period.ago.to_i}.sort
        if new_sort.length > DeviseTrackableIp.max_visits_retained_per_user_ip
          new_sort.shift(new_sort.length-DeviseTrackableIp.max_visits_retained_per_user_ip)
        end
        self.visited_at=new_sort
      end

      def visited_at
        obj = read_attribute(:visited_at)
        case obj.class.name
        when 'NilClass'
          []
        when 'String'
          JSON.parse(obj)
        else
          obj
        end
      end

      def ip_address
        unless read_attribute(:ip_address).nil?
          IPAddr.new(read_attribute(:ip_address).to_i, read_attribute(:ip_address_type))
        end
      end
    end
  end
end