# lib/devise-trackable-ip/schema.rb
module DeviseTrackableIp
  class Schema < ActiveRecord::Schema

    def trackable_ip(options={})
      table = (options[:table] || DeviseTrackableIp.table_name)

      create_table(table) do |t|
        t.bigint :trackable_id, null: false
        t.string :trackable_type, null: false
        t.binary :ip_address, null: false, limit: 16
        t.integer :ip_address_type, null: false
        t.datetime :visited_at, null: false

        t.index %i[trackable_id trackable_type]
        t.index %i[trackable_id trackable_type ip_address ip_address_type]
      end
    end
  end
end