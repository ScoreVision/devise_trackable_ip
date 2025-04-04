# lib/devise-trackable-ip/models/trackable_ip.rb
module DeviseTrackableIp
  module Models
    class TrackableIp < ActiveRecord::Base
      self.table_name = DeviseTrackableIp.table_name

      serialize :visited_at, coder: JSON, type: Array

      SUCCESS = 0
      FAILURE = 1
      UNCONFIRMED = 2

      STATUS_LOOKUP = {
        0 => 'success',
        1 => 'failure',
        2 => 'unconfirmed',
      }.freeze

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

      def add_visit(timestamp, success)
        jsob = self.visited_at
        jsob << [timestamp.to_i, success]
        # Weird ruby hash.keys behaviour that turns integer keys into strings when you call .keys?
        jsob.reject! {|x| x[0] < DeviseTrackableIp.retention_period.ago.to_i}
        # turn them back into ints i guess?
        jsob.sort! {|a,b| a[0] <=> b[0]}
        jsob.shift while jsob.length > DeviseTrackableIp.max_visits_retained_per_user_ip
        self.visited_at=jsob
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