# frozen_string_literal: true

# After each sign in, update sign in time, sign in count and sign in IP.
# This is only triggered when the user is explicitly set (with set_user)
# and on authentication. Retrieving the user from session (:fetch) does
# not trigger it.
Warden::Manager.after_set_user except: :fetch do |record, warden, options|
  if record.respond_to?(:update_tracked_ip) && warden.authenticated?(options[:scope]) && !warden.request.env['devise.skip_trackable']
    record.update_tracked_ip(warden.request, DeviseTrackableIp::Models::TrackableIp::SUCCESS)
  end
end

# Log some failures. From https://stackoverflow.com/questions/12873957/devise-log-after-auth-failure#:~:text=Warden%3A%3AManager.before_failure%20do%20%7Cenv%2C%20opts%7C
Warden::Manager.before_failure do |env, opts|
  usr_obj = env["action_dispatch.request.request_parameters"]&.[](:user)
  email = usr_obj&.[](:email) || usr_obj&.[](:login)
  user_exists = User.where(username: email).exists?

  if opts[:message] == :unconfirmed
    ::Rails.logger.info "*** Login Failure: unconfirmed account access: #{email}"
    if user = User.where('username = ? or email = ?', email, email)
      user.update_tracked_ip(env, DeviseTrackableIp::Models::TrackableIp::UNCONFIRMED)
    end
  elsif opts[:action] == "unauthenticated"
    if !user_exists
      ::Rails.logger.info "*** Login Failure: bad email address given: #{email}"
    else
      ::Rails.logger.info "*** Login Failure: email-password mismatch: #{email}"
      if user = User.where('username = ? or email = ?', email, email).first
        user.update_tracked_ip(env, DeviseTrackableIp::Models::TrackableIp::FAILURE)
      end
    end
  end
end
