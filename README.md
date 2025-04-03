rails generate devise_trackable_ip:install --model=User

rails db:migrate

Add :trackable_ip to your User model:


  > class User < ApplicationRecord<br>
  > devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable, :trackable_ip<br>
  > end

Alter the retention period or max visit retention limit in an initializer if required.
DeviseTrackableIp.configure do |config|
config.retention_period = 6.months
config.max_visits_retained_per_user_ip = 1000
end
