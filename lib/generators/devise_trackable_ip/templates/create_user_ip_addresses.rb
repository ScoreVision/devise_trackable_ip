# lib/generators/devise-trackable-ip/templates/create_user_ip_addresses.rb
class Create<%= DeviseTrackableIp.table_name.camelize %> < ActiveRecord::Migration[<%= ActiveRecord::VERSION::MAJOR %>.<%= ActiveRecord::VERSION::MINOR %>]
def change
  <%= DeviseTrackableIp::Schema.new.trackable_ip %>
  end
end