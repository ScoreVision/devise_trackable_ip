# lib/generators/devise-trackable-ip/install_generator.rb
require 'rails/generators'
require 'rails/generators/active_record'

module DeviseTrackableIp
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def create_migration_file
        model = DeviseTrackableIp.table_name.downcase
        migration_template 'create_trackable_ip_addresses.rb.erb', "db/migrate/create_#{model}.rb", assigns: {table: model}
      end

      def inject_devise_trackable_ip_content
        path = File.join('app', 'models', "#{options[:model].downcase}.rb")
        if File.exist?(path)
          inject_into_file(path, after: /devise .* :database_authenticatable,/) do
            "\n         :trackable_ip,"
          end
        else
          puts "    Model #{options[:model]} not found. Skipping trackable_ip injection."
        end
      end

      def schedule_cleanup_job
        DeviseTrackableIp.schedule_cleanup
      end

      class_option :model, type: :string, default: 'user', desc: 'Name of the model'
    end
  end
end