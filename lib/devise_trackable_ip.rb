# lib/devise-trackable-ip.rb
require 'devise'
require 'active_record'
require 'active_job'

module DeviseTrackableIp
  autoload :Schema, 'devise_trackable_ip/schema'
  #  autoload :TrackableIp, 'devise_trackable_ip/trackable_ip'
  autoload :CleanUpJob, 'devise_trackable_ip/clean_up_job'

  module Models
    autoload :TrackableIp, 'devise_trackable_ip/models/trackable_ip'
  end

  def self.configure
    yield self
  end

  def self.table_name
    @table_name || 'trackable_ips'
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.max_visits_retained_per_user_ip
    @max_visits_retained_per_user_ip || 1000
  end

  def self.max_visits_retained_per_user_ip=(value)
    @max_visits_retained_per_user_ip = value
  end

  def self.retention_period
    @retention_period || 6.months
  end

  def self.retention_period=(retention_period)
    @retention_period = retention_period
  end

  def self.schedule_cleanup
    DeviseTrackableIp::CleanUpJob.set(wait: 6.hours).perform_later
  end

  def self.cleanup_now
    DeviseTrackableIp::Models::TrackableIp.clean_up(retention_period.ago)
  end
end

Devise.add_module :trackable_ip, strategy: false, model: 'devise/models/trackable_ip'


# devise.add_module(:ldap_authenticatable, {
#   strategy: true,
#   controller: :sessions,
#   model: 'devise/models/ldap_authenticatable',
#   route: :session
# })
