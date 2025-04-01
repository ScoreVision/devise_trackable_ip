# lib/devise-trackable-ip/schema.rb
module DeviseTrackableIp
  module Schema
    def trackable_ip
      create_table DeviseTrackableIp.table_name do |t|
        t.references :user, polymorphic: true, null: false, index: true
        t.string :ip_address, null: false
        t.datetime :visited_at, null: false

        t.index [:user_id, :user_type, :ip_address, :visited_at], name: 'index_user_ip_visits'
      end
    end
  end
end