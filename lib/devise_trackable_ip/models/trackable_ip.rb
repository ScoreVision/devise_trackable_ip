# lib/devise-trackable-ip/models/trackable_ip.rb
module DeviseTrackableIp
  module Models
    class TrackableIp < ActiveRecord::Base
      self.table_name = DeviseTrackableIp.table_name

      belongs_to :user, polymorphic: true

      validates :ip_address, presence: true
      validates :visited_at, presence: true
      validates :user_id, presence: true
      validates :user_type, presence: true

      def self.clean_up(older_than)
        where('visited_at < ?', older_than).delete_all
      end
    end
  end
end