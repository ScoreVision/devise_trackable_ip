# devise-trackable-ip.gemspec
require_relative 'lib/devise_trackable_ip/version'

Gem::Specification.new do |spec|
  spec.name          = 'devise-trackable-ip'
  spec.version       = DeviseTrackableIp::VERSION
  spec.authors       = ['Marc Hassman']
  spec.email         = ['marc.hassman@scorevision.com']

  spec.summary       = 'Extracts Devise trackable to a separate table for IP tracking.'
  spec.description   = 'Tracks user IP addresses and visit timestamps in a separate table, truncating data after a configurable time using ActiveJob, ensuring single job queue.'
  spec.homepage      = 'https://github.com/ScoreVision/devise-trackable-ip'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('lib/**/*')
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'devise', '~> 4.9'
  spec.add_development_dependency 'activejob', '~> 7.0', '> 7.0'
  spec.add_development_dependency 'rspec-rails', '~> 6.0', '> 6.0'
end
