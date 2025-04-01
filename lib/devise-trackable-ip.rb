# lib/devise-trackable-ip.rb
require 'devise'
require 'active_record'
require 'active_job'

module DeviseTrackableIp
  autoload :Schema, 'devise_trackable_ip/schema'
  autoload :TrackableIp, 'devise_trackable_ip/trackable_ip'
  autoload :CleanUpJob, 'devise_trackable_ip/clean_up_job'

  module Models
    autoload :TrackableIp, 'devise_trackable_ip/models/trackable_ip'
  end

  def self.configure
    yield self
  end

  def self.table_name
    @table_name || :user_ip_addresses
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.retention_period
    @retention_period || 6.months
  end

  def self.retention_period=(retention_period)
    @retention_period = retention_period
  end

  def self.schedule_cleanup
    DeviseTrackableIp::CleanUpJob.set(wait: 1.day).perform_later unless DeviseTrackableIp::CleanUpJob.job_exists?
  end

  def self.cleanup_now
    DeviseTrackableIp::Models::TrackableIp.clean_up(retention_period.ago)
  end
end

Devise.add_module :trackable_ip, model: 'devise_trackable_ip/models/trackable_ip'
